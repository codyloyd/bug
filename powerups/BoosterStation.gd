extends "res://powerups/PowerupStation.gd"


func _ready():
	if PlayerStats.boosters_unlocked:
		$AnimationPlayer.play('used')

func on_powerup_triggered():
	if not PlayerStats.boosters_unlocked:
		Sfx.play("Powerup", 1, -10)
		PlayerStats.boosters_unlocked = true
		Events.emit_signal("display_message", "Boosters Activated", "Press jump while in air")
		.on_powerup_triggered()