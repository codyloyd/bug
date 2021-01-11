extends "res://powerups/PowerupStation.gd"


func _ready():
	if PlayerStats.bombs_unlocked:
		$AnimationPlayer.play('used')

func on_powerup_triggered():
	if not PlayerStats.bombs_unlocked:
		Sfx.play("Powerup", 1, -10)
		PlayerStats.bombs_unlocked = true
		Events.emit_signal("display_message", "Bombs Activated", "Press R to select weapon")
		.on_powerup_triggered()