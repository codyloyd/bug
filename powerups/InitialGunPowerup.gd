extends "res://powerups/PowerupStation.gd"

func _ready():
	if SaverAndLoader.custom_data.gun_unlocked:
		$AnimationPlayer.play("used")

func on_powerup_triggered():
	if not SaverAndLoader.custom_data.gun_unlocked:
		Sfx.play("Powerup", 1, -10)
		Events.emit_signal('display_message', 'blaster activated', 'aim with mouse, click to shoot')
		Events.emit_signal('gun_unlocked')
		SaverAndLoader.custom_data.gun_unlocked = true
		.on_powerup_triggered()


