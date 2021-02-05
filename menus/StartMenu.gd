extends ColorRect

var PlayerStats = ResourceLoader.PlayerStats
onready var dialog = $ConfirmationDialog
onready var viewport = $ViewportContainer/Viewport
onready var load_button = $ViewportContainer/Viewport/VBoxContainer2/LoadButton

func _ready(): 
	dialog.connect("confirmed", self, "start_game")
	# MUTE ALL AUDIO
	# AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	if not SaverAndLoader.save_file_exists():
		load_button.disabled = true

func _on_StartButton_pressed():
	if SaverAndLoader.save_file_exists():
		dialog.popup()
	else:
		start_game()

func start_game():
	PlayerStats.initialize()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/IntroScene.tscn")
	# get_tree().change_scene("res://Game.tscn")

func _on_LoadButton_pressed():
	SaverAndLoader.is_loading = true
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game.tscn")

func _on_CreditsButton_pressed():
	$CreditsDialog.popup()
