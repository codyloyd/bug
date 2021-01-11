extends ColorRect

var scene_over = false

func _ready():
	Events.emit_signal("clear_screen")
	Music.list_index = 3
	Music.play_music()

func BOOM():
	scene_over = true

func _input(event):
	if event is InputEventKey and event.pressed and scene_over:
		Music.list_index = 4
		Music.play_music()
		# warning-ignore:return_value_discarded
		SaverAndLoader.is_loading = true
		get_tree().change_scene("res://Game.tscn")
