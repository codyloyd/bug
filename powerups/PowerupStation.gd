extends Node2D

var PlayerStats = ResourceLoader.PlayerStats
onready var particles = $CPUParticles2D

func _ready():
	particles.emitting = false

func on_powerup_triggered():
	$AnimationPlayer.play('used')
	particles.visible = true
	particles.emitting = true
	SaverAndLoader.save_custom_data()

func _on_Area2D_body_entered(body: Player):
	on_powerup_triggered()
