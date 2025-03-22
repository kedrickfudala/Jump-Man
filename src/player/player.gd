extends CharacterBody2D
class_name Player

@onready var speed : int = 35
@onready var jumps : int = 2
@onready var dir = 0
@onready var dash_dir : Vector2 = Vector2(0,0)
@onready var falling : bool = false
@onready var dashing : bool = false

@onready var coins : int = 0

func handle_input(delta):
	dir = Input.get_axis("ui_left", "ui_right")
	dash_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if is_on_floor():
		jumps = 2
		falling = false
		$JumpAnimTimer.stop()
		$DashAnimTimer.stop()
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("jump"):
			set_collision_mask_value(8, false)
		else:
			set_collision_mask_value(8, true)
	else:
		if Input.is_action_just_pressed("jump") and jumps > 0:
			velocity.y = -225
			jumps -= 1
			falling = false
			$JumpAnimTimer.stop()
			$JumpSFX.play()
	if Input.is_action_just_pressed("dash") and $DashCooldown.is_stopped() and dash_dir != Vector2(0,0):
		velocity = dash_dir * 200
		$DashCooldown.start()
		$DashAnimTimer.start()
		$DashSFX.play()
	if $DashAnimTimer.is_stopped():
		velocity.x += dir * speed
		velocity.y += 10
		velocity.x *= 0.8
	move_and_slide()

func handle_anims():
	if dir > 0:
		$Sprite.flip_h = 0
	elif dir < 0:
		$Sprite.flip_h = 1
	
	if !$DashAnimTimer.is_stopped():
		$Sprite.play("dash")
	elif !is_on_floor():
		$RunSFX.stop()
		if velocity.y < 0:
			$Sprite.play("jump_up")
		if velocity.y > 0:
			if $JumpAnimTimer.is_stopped():
				$JumpAnimTimer.start()
			if falling:
				$Sprite.play("fall_down")
			else:
				$Sprite.play("midair")
	elif dir != 0:
		$Sprite.play("run")
		if !$RunSFX.playing and is_on_floor():
			$RunSFX.play()
	else:
		$Sprite.play("idle")
		$RunSFX.stop()

func pickup_coin():
	coins += 1
	$PickupSFX.play()

func _physics_process(delta: float) -> void:
	handle_input(delta)
	handle_anims()

func _on_jump_anim_timer_timeout() -> void:
	falling = true
