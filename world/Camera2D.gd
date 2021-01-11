extends Camera2D

var MainInstances = ResourceLoader.MainInstances

onready var shakeTimer = $ShakeTimer
onready var tween = $Tween
var shake = 0

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("screen_shake", self, "screen_shake")
	MainInstances.WorldCamera = self

func _process(_delta):
	var shake_value = shake * shakeTimer.time_left
	offset_h = rand_range(-shake_value, shake_value)
	offset_v = rand_range(-shake_value, shake_value)
	
	
func screen_shake(amount, duration):
	shake = amount
	shakeTimer.wait_time = duration
	shakeTimer.start()


func _on_ShakeTimer_timeout():
	shake = 0

func _on_Tween_tween_all_completed():
	smoothing_enabled = false