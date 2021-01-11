extends TextureRect

onready var shader = self.get_material()


func _ready():
	Events.connect("glitch", self, "on_glitch_event")
	shader.set_shader_param("aberAmt", 0)

func on_glitch_event(amount, duration):
	shader.set_shader_param("aberAmt", amount)
	$Timer.wait_time = duration
	$Timer.start()

func _on_Timer_timeout():
	shader.set_shader_param("aberAmt", 0)