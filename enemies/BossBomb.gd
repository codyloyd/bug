extends RigidBody2D


const ExplosionEffect = preload("res://effects/BombExplostionEffect.tscn")

func boom():
	Utils.add_scene_to_main(ExplosionEffect, global_position)
	queue_free()

func _on_Hurtbox_hit(_damage):
	boom()
