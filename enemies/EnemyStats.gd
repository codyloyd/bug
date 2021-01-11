extends Node

export(int) var max_health = 1
export(int) var health = max_health setget set_enemy_health

signal enemy_died

func set_enemy_health(value):
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("enemy_died")
