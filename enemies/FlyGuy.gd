extends "res://enemies/Enemy.gd"

const Bullet = preload("res://player/EnemyBullet.tscn")

func _ready():
	pass

func _on_Area2D_body_entered(Player):
	var player_direction = (Player.global_position - $Muzzle.global_position).normalized()
	var bullet_position = $Muzzle.global_position
	var bullet = Utils.add_scene_to_main(Bullet, bullet_position)
	bullet.velocity = player_direction * 50 
	bullet.rotation = player_direction.angle()