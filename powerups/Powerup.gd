extends Area2D

const effect = preload("res://effects/PupEffect.tscn")

func _ready():
	pass

func pickup():
	SaverAndLoader.save_game()
