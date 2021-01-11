extends "res://powerups/PowerupStation.gd"


func _ready():
	if SaverAndLoader.custom_data.zap_ray_unlocked:
		$AnimationPlayer.play("used")

func on_powerup_triggered():
	if not SaverAndLoader.custom_data.zap_ray_unlocked:
		Sfx.play("Powerup", 1, -10)
		Events.emit_signal('display_message', 'zap-ray activated', 'press R to switch weapons')
		SaverAndLoader.custom_data.zap_ray_unlocked = true
		.on_powerup_triggered()
