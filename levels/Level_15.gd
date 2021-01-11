extends "res://levels/Level.gd"


func _ready():
	if not SaverAndLoader.custom_data.boss1_defeated:
		Music.list_index = 3
		Music.play_music()
