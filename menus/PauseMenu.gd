extends ColorRect

var paused = false setget set_paused

func _ready():
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		self.paused = !paused
		Events.emit_signal('game_paused')

func set_paused(value):
	paused = value
	visible = paused
	get_tree().paused = paused

func _on_Button_pressed():
	self.paused = false

