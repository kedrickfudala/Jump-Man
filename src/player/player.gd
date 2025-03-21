extends CharacterBody2D
class_name Player

@onready var speed = 35
@onready var jumps = 2
@onready var dir = 0
@onready var falling : bool = false

func handle_input(delta):
	dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if is_on_floor():
		jumps = 2
		falling = false
		$JumpTimer.stop()
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_up"):
			set_collision_mask_value(8, false)
		else:
			set_collision_mask_value(8, true)
	else:
		if Input.is_action_just_pressed("ui_up") and jumps > 0:
			velocity.y = -250
			jumps -= 1
			falling = false
			$JumpTimer.stop()

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
		if velocity.y > 0:
			if $JumpTimer.is_stopped():
				$JumpTimer.start()
			if falling:
				$Sprite.play("fall_down")
			else:
				$Sprite.play("midair")
	elif dir != 0:
		$Sprite.play("run")
	else:
		$Sprite.play("idle")

func _physics_process(delta: float) -> void:
	handle_input(delta)
	handle_anims()

func _on_jump_timer_timeout() -> void:
	falling = true
