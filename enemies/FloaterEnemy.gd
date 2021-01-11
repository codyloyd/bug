extends "res://enemies/Enemy.gd"

var Bomb = preload("res://enemies/BossBomb.tscn")

func drop_bomb():
	var bomb = Utils.add_scene_to_main(Bomb, global_position)
	bomb.linear_velocity = Vector2(rand_range(-10,10), 0)

