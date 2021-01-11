extends "res://player/Projectile.gd"

func _ready():
	ExplosionEffect = preload("res://effects/EnemyExplosionEffect.tscn")

# var velocity = Vector2.ZERO

# func _process(delta):
# 	position += velocity * delta


# func _on_VisibilityNotifier2D_screen_exited():
# 	queue_free()


# func _on_Hitbox_body_entered(body):
# 	Utils.add_scene_to_main(ExplosionEffect, global_position)
# 	queue_free()


# func _on_Hitbox_area_entered(area):
# 	Utils.add_scene_to_main(ExplosionEffect, global_position)
# 	queue_free()
