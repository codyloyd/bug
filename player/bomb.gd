extends Node2D

const ExplosionEffect = preload("res://effects/BombExplostionEffect.tscn")

# needed for the walker
onready var animation_player = $AnimationPlayer

func boom():
	Utils.add_scene_to_main(ExplosionEffect, global_position)
	queue_free()
