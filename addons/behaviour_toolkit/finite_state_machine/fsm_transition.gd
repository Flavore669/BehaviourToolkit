@tool
@icon("res://addons/behaviour_toolkit/icons/FSMTransition.svg")
class_name FSMTransition extends BehaviourToolkit
## A transition between two [FSMState]s in a [FiniteStateMachine].
##
## This is the base class for all transitions. To implement your logic you can
## override the [code]_on_transition[/code] method when extending the node's
## script.[br]
## To setup custom conditions you can override the is_valid method.[br]
## If you want to use events to trigger the transition, set
## [code]use_event[/code] to true and set the event property to the name
## of the event you want to listen for.


## The state to transition to.
@export var next_state: FSMState:
	set(value):
		next_state = value
		update_configuration_warnings()

@export_category("Transition Logic")
## If true, the FSM will check for the event to trigger the transition.
@export var use_event: bool = false:
	set(value):
		use_event = value
		update_configuration_warnings()
## The event that triggers the transition.
@export var event: String = "":
	set(value):
		event = value
		update_configuration_warnings()


## Executed when the transition is taken.
func _on_transition(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	pass


## Evaluates true, if the transition conditions are met.
func is_valid(_actor: Node, _blackboard: Blackboard) -> bool:
	return false


func is_valid_event(current_event: String) -> bool:
	if current_event == "":
		return false

	return current_event == event


## Returns which state to transition to, when valid.
func get_next_state() -> FSMState:
	return next_state


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	var parent: Node = get_parent()
	if not parent is FSMState:
		warnings.append("FSMTransition should be a child of FSMState.")
	
	if not next_state:
		warnings.append("FSMTransition has no next state.")
		return warnings
	
	if use_event and event == "":
		warnings.append("FSMTransition has no event set.")
	
	var fsm := _find_fsm()
	if fsm:
		# Generate arrays of node names to compare.
		var our_path := fsm.get_path_to(get_parent()).get_concatenated_names().split("/") # Node names from FSM to parent state
		var their_path := fsm.get_path_to(next_state).get_concatenated_names().split("/") # Node names from FSM to next_state
		
		print(name, " Our Path: ", our_path)
		print(name, " Next Path: ", their_path)
		
		# Handle mismatch case. Where one is >=2, the other is <2
		# This is to avoid accessesing elements that don't exist
		if (our_path.size() >= 2) != (their_path.size() >= 2):
			warnings.append("FSMTransition should not transition outside of this NestedFSM.")
		# Compare their sizes to check for nesting, then compare their parent states to check if they're the same using length - 2
		elif our_path.size() != their_path.size() or our_path[-2] != their_path[-2]:
			warnings.append("FSMTransition should not transition outside of this NestedFSM.")

	return warnings

func _find_fsm() -> FiniteStateMachine:
	var current: Node = self
	while current:
		if current is FiniteStateMachine:
			return current as FiniteStateMachine
		current = current.get_parent()
	return null
