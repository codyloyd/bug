extends Node2D


var timer = 0

func _ready():
	Events.connect('glitch_on', self, "on_glitch_on")
	Events.connect('glitch_off', self, "on_glitch_off")
	visible = false
	pass

func _process(delta):
	timer += delta
	if timer > .03:
		timer = 0
		var lights = get_children()
		for l in lights:
			l.texture_scale = rand_range(.3, 2)

func on_glitch_on():
	visible = true;

func on_glitch_off():
	visible = false;