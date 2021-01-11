extends Area2D 

var PlayerStats = ResourceLoader.PlayerStats
onready var parent = get_parent().get_path()

func _ready():
	pass

func pickup():
	Sfx.play("Powerup2", 1, -12)
	PlayerStats.max_health += 1
	PlayerStats.health = PlayerStats.max_health
	Events.emit_signal("health_increased", PlayerStats.health)
	Events.emit_signal("display_message", "", "Max health increased")
	PersistantBricks.save_brick(global_position, parent)
	SaverAndLoader.save_custom_data()
	queue_free()
