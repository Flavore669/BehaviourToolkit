extends CharacterBody2D


const SPEED := 100.0
const SPRINT_MULTIPLIER := 1.7


var movement_direction := Vector2.ZERO
var in_action := false

@onready var state_machine := $FSMController
@onready var sprite := $Character
@onready var animation_player := $AnimationPlayer
@onready var particles_walking := $ParticlesWalking


func _physics_process(_delta):
	movement_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		in_action = true if event.button_index == MOUSE_BUTTON_LEFT and event.pressed else false 

func _ready():
	state_machine.start()

func _on_fsm_controller_state_changed(state: FSMState) -> void:
	#print("Base FSM: ", state.name, " ", Time.get_ticks_msec())
	pass

func _on_movement_fsm_nested_state_changed(state: FSMState) -> void:
	#print("Movement FSM: ", state.name, " ", Time.get_ticks_msec())
	pass

func _on_action_fsm_nested_state_changed(state: FSMState) -> void:
	#print("Action FSM: ", state.name, " ", Time.get_ticks_msec())
	pass
