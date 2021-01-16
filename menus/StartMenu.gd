extends ColorRect

var PlayerStats = ResourceLoader.PlayerStats

func _ready(): 
	# MUTE ALL AUDIO
	# AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	if not SaverAndLoader.save_file_exists():
		$VBoxContainer/LoadButton.visible = false

func _on_StartButton_pressed():
	PlayerStats.initialize()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/IntroScene.tscn")
	# get_tree().change_scene("res://Game.tscn")

func _on_LoadButton_pressed():
	SaverAndLoader.is_loading = true
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game.tscn")
