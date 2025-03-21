extends CharacterBody2D
class_name Player

@onready var speed = 25

func handle_input(delta):
	var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	velocity.x += dir * speed
	velocity.x *= 0.8
	velocity.y += 10

func _physics_process(delta: float) -> void:
	handle_input(delta)
	move_and_slide()
