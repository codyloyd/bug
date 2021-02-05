extends "res://enemies/Enemy.gd"

const Bullet = preload("res://player/EnemyBullet.tscn")
var MainInstances = ResourceLoader.MainInstances
var burst_count = 0

signal boss_died

func _ready():
	pass # Replace with function body.

func _on_BurstTimer_timeout():
	if burst_count == 0:
		return

	burst_count -= 1
	var player = MainInstances.Player
	var player_direction = (player.global_position - $Muzzle.global_position).normalized()

	var bullet_position = $Muzzle.global_position
	var bullet = Utils.add_scene_to_main(Bullet, bullet_position)
	bullet.velocity = player_direction * 70 
	bullet.rotation = player_direction.angle()


func _on_ShotTimer_timeout():
	burst_count = 3

func die():
	emit_signal("boss_died")
	queue_free()
