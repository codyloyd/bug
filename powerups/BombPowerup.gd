extends "res://powerups/Powerup.gd"

var PlayerStats = ResourceLoader.PlayerStats

func _ready():
	if PlayerStats.bombs_unlocked:
		queue_free()

func pickup():
	Sfx.play("Powerup", 1, -10)
	PlayerStats.bombs_unlocked = true
	Events.emit_signal("display_message", "Bombs Activated", "Press 2 to toggle then click to set!")
	.pickup()
