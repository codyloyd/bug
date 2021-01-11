extends StaticBody2D

var PlayerStats = ResourceLoader.PlayerStats
onready var particles = $CPUParticles2D

func _ready():
	particles.emitting = false
	pass

func _on_Area2D_body_entered(body):
	Events.emit_signal("display_message", "", "game saved")
	Sfx.play("Riser", 1, -2)
	SaverAndLoader.save_game()
	particles.visible = true
	particles.emitting = true
	PlayerStats.health = PlayerStats.max_health
