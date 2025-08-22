extends CharacterBody2D


const SPEED := 100.0
const SPRINT_MULTIPLIER := 1.7


var movement_direction := Vector2.ZERO


@onready var state_machine := $FSMController
@onready var sprite := $Character
@onready var animation_player := $AnimationPlayer
@onready var particles_walking := $ParticlesWalking


func _physics_process(_delta):
	movement_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)


func _ready():
	state_machine.start()

func _on_fsm_controller_state_changed(state: FSMState) -> void:
	print(state.name)


func _on_movement_fsm_nested_state_changed(state: FSMState) -> void:
	print(state.name)
