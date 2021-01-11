extends "res://levels/Level.gd"

onready var TheSystem = $TheSystem
onready var InvisibleBarrier = $InvisibleBarrier

func _ready():
	# TheSystem.queue_free()
	# InvisibleBarrier.queue_free()
	Events.connect('system_access_granted', self, "on_system_access_granted")


func _on_GameEndTrigger_body_entered(_body):
	$AnimationPlayer.play('gameover')

func change_to_game_over():
	get_tree().change_scene("res://game-screens/GAME_OVER.tscn")

func on_system_access_granted():
	InvisibleBarrier.queue_free()
