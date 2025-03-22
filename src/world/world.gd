extends Node2D
class_name World

@onready var levels = {
	"level_1" : 2
}

func _ready():
	RenderingServer.set_default_clear_color(Color("2e5a89"))
	$MusicPlayer.play()
