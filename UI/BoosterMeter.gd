extends Control

var MainInstances = ResourceLoader.MainInstances
onready var rect = $ColorRect
onready var display_timer = $DisplayTimer

func _ready():
# warning-ignore:return_value_discarded
	Events.connect('booster_timer_update', self, 'update_timer')

func update_timer(time):
	visible = true
	rect.rect_scale.x = time
	if time >= 1:
		display_timer.start()


func _on_DisplayTimer_timeout():
	visible = false
