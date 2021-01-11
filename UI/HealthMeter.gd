extends Control

var PlayerStats = ResourceLoader.PlayerStats
onready var empty = $HealthMeterEmpty
onready var full = $HealthMeterFull

func _ready():
	PlayerStats.connect("player_update_health", self, "on_player_update_health")
	Events.connect("health_increased", self, "on_player_update_health")


func on_player_update_health(health):
	var max_health = PlayerStats.max_health
	empty.rect_size.x = max_health * 2 + 1
	full.rect_size.x = health * 2 + 1
