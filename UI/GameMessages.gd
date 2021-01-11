extends Control

onready var upper = $upper
onready var lower = $lower
onready var Timer = $Timer

func _ready():
	Events.connect('display_message', self, 'on_display_message')
	Events.connect('clear_message', self, 'on_clear_message')

func on_display_message(upper_message, lower_message):
	upper.text = upper_message
	lower.text = lower_message
	Timer.start()

func on_clear_message():
	pass


func _on_Timer_timeout():
	upper.text = ""
	lower.text = ""
