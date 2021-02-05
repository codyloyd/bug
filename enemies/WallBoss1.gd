extends "res://enemies/Enemy.gd"

var Bomb = preload("res://enemies/BossBomb.tscn")
onready var muzzle = $Muzzle

signal boss_died

func _ready():
	pass # Replace with function body.


func _on_Timer_timeout():
	var bomb = Utils.add_scene_to_main(Bomb, muzzle.global_position)
	bomb.linear_velocity = Vector2(rand_range(-160,-20), rand_range(-30,0))

func die():
	emit_signal("boss_died")
	queue_free()