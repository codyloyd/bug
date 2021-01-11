extends "res://player/Projectile.gd"

onready var explosion = preload("res://effects/EnemyExplosionEffect.tscn")

func _ready():
	pass

func _exit_tree():
	Utils.add_scene_to_main(explosion, global_position)
