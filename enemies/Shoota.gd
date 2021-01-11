extends "res://enemies/Enemy.gd"

const Bullet = preload("res://player/ShootaProjectile.tscn")
onready var muzzle = $Muzzle
onready var aim = $Aim


func _ready():
	pass

func _on_Timer_timeout():
	var dir = (aim.global_position - muzzle.global_position).normalized()
	var bullet_position = muzzle.global_position
	var bullet = Utils.add_scene_to_main(Bullet, bullet_position)
	bullet.velocity = dir * 30 

func take_hit(damage):
	$HITPLAYER.play('hit')
	.take_hit(damage)
