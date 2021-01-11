extends "res://powerups/Powerup.gd"


var PlayerStats = ResourceLoader.PlayerStats
onready var parent = get_parent().get_path()

func _ready():
	pass

func pickup():
	Sfx.play("Powerup2", 1, -12)
	SaverAndLoader.custom_data.burst_limit += 1
	Events.emit_signal('gun_upgrade')
	Events.emit_signal("display_message", "Blaster Upgraded", "Hold fire for burst")
	PersistantBricks.save_brick(global_position, parent)
	SaverAndLoader.save_custom_data()
	queue_free()