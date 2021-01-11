extends Node2D

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var FLY_DIRECTION = DIRECTION.LEFT

var Enemy = preload("res://enemies/SpawnEnemy.tscn")
onready var spawn_point = $Position2D

func _ready():
	$AnimationPlayer.play('spawn') 

func spawn_enemy():
	var parent = get_tree().get_root().get_node("Game")
	if parent:
		var newEnemy = Enemy.instance()
		newEnemy.FLY_DIRECTION = FLY_DIRECTION
		parent.current_level.add_child(newEnemy)
		newEnemy.global_position = spawn_point.global_position

func _on_Timer_timeout():
	$AnimationPlayer.play('spawn') 