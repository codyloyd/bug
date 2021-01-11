extends Node2D

var ExplosionEffect = preload("res://effects/SmallExplosion.tscn")

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Hitbox_body_entered(_body):
	Utils.add_scene_to_main(ExplosionEffect, global_position)
	queue_free()


func _on_Hitbox_area_entered(area):
	if area is Switch:
		area.open_gate()

	Utils.add_scene_to_main(ExplosionEffect, global_position)
	queue_free()
