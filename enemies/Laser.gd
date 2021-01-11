extends Node2D

onready var raycast = $RayCast2D
onready var line = $Line2D
onready var whiteline = $Line2D2
onready var light = $Light2D
onready var particles = $Particles

var timer = 0

func _ready():
	turn_off()

func _physics_process(delta):
	timer += delta
	if timer > .06:
		timer = 0
		light.texture_scale = rand_range(.3, 2)

	var collider = raycast.get_collider()
	var coll_point = raycast.get_collision_point()
	particles.global_position = coll_point
	whiteline.set_point_position(1, (coll_point - line.global_position).rotated(-rotation))
	line.set_point_position(1, (coll_point - line.global_position).rotated(-rotation))
	var width = [1,3,5]
	width.shuffle()
	line.width = width[0]

	if collider and collider.is_in_group("player"):
		collider.take_hit(1)

func turn_off():
	line.visible = false
	whiteline.visible = false
	light.visible = false
	raycast.enabled = false
	particles.emitting = false


func turn_on():
	line.visible = true
	whiteline.visible = true
	light.visible = true
	raycast.enabled = true
	particles.emitting = true
