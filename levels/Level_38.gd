extends "res://levels/Level.gd"


func _ready():
	if not Music.list_index == 4:
		Music.list_index = 4
		Music.play_music()
