extends ColorRect

var PlayerStats = ResourceLoader.PlayerStats
onready var dialog = $ConfirmationDialog

func _ready(): 
	dialog.connect("confirmed", self, "start_game")
	# $ConfirmationDialog.get_cancel().connect("pressed", self, "cancelled").
	# MUTE ALL AUDIO
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	if not SaverAndLoader.save_file_exists():
		$VBoxContainer/LoadButton.disabled = true

func _on_StartButton_pressed():
	dialog.popup()

func start_game():
	PlayerStats.initialize()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/IntroScene.tscn")
	# get_tree().change_scene("res://Game.tscn")

func cancelled():
	print('cancelled')

func _on_LoadButton_pressed():
	pass
# 	SaverAndLoader.is_loading = true
# # warning-ignore:return_value_discarded
# 	get_tree().change_scene("res://Game.tscn")
