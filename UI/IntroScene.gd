extends Control


func _ready():
	Music.play_intro()
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene("res://Game.tscn")

func _gui_input(event):
	if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				get_tree().change_scene("res://Game.tscn")