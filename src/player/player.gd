extends CharacterBody2D
class_name Player

@onready var speed = 30
@onready var jumps = 2
@onready var dir = 0
@onready var falling : bool = false

func handle_input(delta):
	dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if is_on_floor():
		jumps = 2
	if Input.is_action_just_pressed("ui_up") and jumps > 0:
		velocity.y = -200
		jumps -= 1

	velocity.x += dir * speed
	velocity.x *= 0.8
	velocity.y += 10
	move_and_slide()

func handle_anims():
	if dir > 0:
		$Sprite.flip_h = 0
	elif dir < 0:
		$Sprite.flip_h = 1
	
	if !is_on_floor():
		if velocity.y < 0:
			$Sprite.play("jump_up")
			falling = false
		if velocity.y > 0:
			if !falling:
				$Sprite.play("midair")
				if !$Sprite.animation == "midair":
					falling = true
			else:
				$Sprite.play("fall_down")
	elif dir != 0:
		$Sprite.play("run")
	else:
		$Sprite.play("idle")

func _physics_process(delta: float) -> void:
	handle_input(delta)
	handle_anims()
