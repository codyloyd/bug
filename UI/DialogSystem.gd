extends Control

onready var Label = $Label

func _ready():
	Label.visible = false
	Events.connect('display_dialog_message', self, 'on_display_dialog_message')
	Events.connect('clear_dialog_message', self, 'on_clear_dialog_message')

func on_display_dialog_message(msg, time = 0):
	if Label.text:
		$AnimationPlayer.playback_speed = 1
		$AnimationPlayer.play('empty')
		yield(get_tree().create_timer(.2), "timeout")

	Label.visible = false
	$AnimationPlayer.playback_speed = 50.0/msg.length()
	$AnimationPlayer.play('reveal')
	Label.text = msg
	Label.visible = true
	if (time > 0):
		yield(get_tree().create_timer(time), "timeout")
		clear()


func on_clear_dialog_message():
	clear()


func clear():
	Label.text = ''
	Label.visible = false
