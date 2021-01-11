extends StaticBody2D

onready var line = $Line2D
onready var line2 = $Line2D2
onready var light = $Light2D

var timer = 0

func _ready():
	pass

func _process(delta):
	timer += delta
	if timer > .06:
		timer = 0
		light.texture_scale = rand_range(.3, 2)
		for i in range(line2.points.size()):
			var pos = line2.get_point_position(i)
			line2.set_point_position(i, Vector2(rand_range(-1.5, 1.5), pos.y))
		for i in range(line.points.size()):
			var pos = line.get_point_position(i)
			line.set_point_position(i, Vector2(rand_range(-1, 1), pos.y))
