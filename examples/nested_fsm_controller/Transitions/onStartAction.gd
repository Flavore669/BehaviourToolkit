extends FSMTransition


# Executed when the transition is taken.
func _on_transition(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	pass


# Evaluates true, if the transition conditions are met.
func is_valid(actor: Node, _blackboard: Blackboard) -> bool:
	if actor is CharacterBody2D and actor.in_action == true:
		return true
	
	return false
