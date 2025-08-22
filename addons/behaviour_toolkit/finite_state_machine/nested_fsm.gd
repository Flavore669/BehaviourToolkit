@tool
extends FSMState
class_name NestedFSM

#TODO: Test NESTED MR BLACKSMITH

## The signal emitted when the fsm's state changes.
signal nested_state_changed(state: FSMState)

@export var initial_state : FSMState
@export var verbose : bool

@onready var fsm = FiniteStateMachine.new()

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint():
		return
	
	
	var nested_states : Array[Node] = get_children().filter(func(n): return n is FSMState)
	var nested_fsms : Array[Node] = get_children().filter(func(n): return n is NestedFSM)
	
	add_child(fsm)
	fsm.name = "NestedFSM"
	
	for state in nested_states: 
		state.reparent(fsm)
		
	for nested_fsm in nested_fsms: 
		nested_fsm.reparent(fsm)
		
	fsm.initial_state = initial_state
	fsm.verbose = verbose
	
	var parent_state_machine : FiniteStateMachine = get_parent()
	fsm.actor = parent_state_machine.actor
	fsm.process_type = parent_state_machine.process_type
	fsm.blackboard = parent_state_machine.blackboard
	
	fsm.state_changed.connect(func(state: FSMState): nested_state_changed.emit(state))

# Executes after the state is entered.
func _on_enter(_actor: Node, _blackboard: Blackboard) -> void:
	fsm.start()

# Executes before the state is exited.
func _on_exit(_actor: Node, _blackboard: Blackboard) -> void:
	fsm.active = false


# Add custom configuration warnings
# Note: Can be deleted if you don't want to define your own warnings.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array = []

	warnings.append_array(super._get_configuration_warnings())

	var parent: Node = get_parent()
	if not parent is FiniteStateMachine:
		warnings.append("NestedFSM should be a child of a FiniteStateMachine node.")
	
	if not initial_state:
		warnings.append("FSM needs an initial state")
	
	return warnings
