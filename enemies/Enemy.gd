extends KinematicBody2D

export(int) var MAX_SPEED = 5
var motion = Vector2(5, 0)

var ExplosionEffect = preload("res://effects/ExplosionEffect.tscn")

onready var stats = $EnemyStats


func _ready():
	stats.connect('enemy_died', self, 'die')


func take_hit(damage):
	Sfx.play('EnemyHit', rand_range(.8, 1.2))
	stats.health -= damage


func die():
	Utils.add_scene_to_main(ExplosionEffect, global_position)
	queue_free()


func _on_Hurtbox_hit(damage):
	take_hit(damage)
