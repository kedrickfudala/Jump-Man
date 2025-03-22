extends Area2D
class_name Coin

@onready var counter = 0

func _physics_process(delta: float) -> void:
	$Sprite.play("coin")
	position.y += sin(counter) / 4
	counter += 0.05
	if counter > 360:
		counter = 0

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().pickup_coin()
	queue_free()
