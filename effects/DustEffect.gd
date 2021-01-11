extends Node2D

var velocity = Vector2(rand_range(2, 6), rand_range(-2,-6))

func _ready():
	pass
	

func _process(delta):
	pass
	position += velocity * delta
