extends "res://powerups/Powerup.gd"

onready var parent = get_parent().get_path()

func _ready():
	pass

func pickup():
	Sfx.play("Powerup2", 1, -12)
	SaverAndLoader.custom_data.zap_ray_level += 1
	Events.emit_signal('zap_ray_upgrade')
	Events.emit_signal("display_message", "Zap Ray Upgraded", "Range Extended and Power Increased")
	PersistantBricks.save_brick(global_position, parent)
	SaverAndLoader.save_custom_data()
	queue_free()