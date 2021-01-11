extends Resource
class_name PlayerStats

signal player_update_health(health)
signal player_die

var max_health = 3 setget set_max_health
var health = max_health setget set_health

var boosters_unlocked = false setget set_boosters_unlocked
signal player_boosters_unlocked

var bombs_unlocked = false setget set_bombs_unlocked
signal player_bombs_unlocked


func _ready():
	health = max_health
	pass

func initialize():
	self.health = max_health
	self.bombs_unlocked = SaverAndLoader.custom_data.bombs_unlocked
	self.boosters_unlocked = SaverAndLoader.custom_data.boosters_unlocked

func set_max_health(value):
	max_health = value
	SaverAndLoader.custom_data.max_health = value

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("player_update_health", health)
	if health == 0:
		emit_signal('player_die')


func set_boosters_unlocked(value):
	boosters_unlocked = value
	SaverAndLoader.custom_data.boosters_unlocked = value
	emit_signal('player_boosters_unlocked')

func set_bombs_unlocked(value):
	bombs_unlocked = value
	SaverAndLoader.custom_data.bombs_unlocked = value 
	emit_signal('player_bombs_unlocked')