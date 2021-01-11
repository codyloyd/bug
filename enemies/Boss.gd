extends "res://enemies/Enemy.gd"


var MainInstances = ResourceLoader.MainInstances
var Bullet = preload("res://enemies/BossProjectile.tscn")
var Bomb = preload("res://enemies/BossBomb.tscn")
var ACCELLERATION = 50
onready var muzzle = $Muzzle

signal boss_died
signal update_health(percentage)

func _ready():
	pass

func _process(delta):
	var player = MainInstances.Player
	chase_player(player, delta)

func chase_player(player, delta):
	var dir = (player.global_position - global_position).normalized()
	motion.x += dir.x * ACCELLERATION * delta
	motion = motion.clamped(MAX_SPEED)

	motion = move_and_slide(motion)


func _on_FireTimer_timeout():
	var bullet = Utils.add_scene_to_main(Bullet, muzzle.global_position)
	var velocity = Vector2.DOWN * 40
	velocity = velocity.rotated(deg2rad(rand_range(-30, 30)))
	bullet.velocity = velocity

func _on_BombTimer_timeout():
	var bomb = Utils.add_scene_to_main(Bomb, muzzle.global_position)
	bomb.linear_velocity = Vector2(rand_range(-10,10), 0)

func take_hit(d):
	emit_signal("update_health", float(stats.health)/float(stats.max_health))
	$HitPlayer.play("oof")
	.take_hit(d)

func die():
	emit_signal("boss_died")
	queue_free()
