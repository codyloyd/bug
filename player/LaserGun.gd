extends Node

onready var ray = $RayCast2D
onready var gun = get_parent()
onready var beam = $Line2D
onready var light = $Light2D

var level = 1

func _ready():
	set_process(false)
	self.visible = false
	ray.enabled = false
	level = SaverAndLoader.custom_data.zap_ray_level
	set_beam_length()
	Events.connect("zap_ray_upgrade", self, "on_upgrade")

func set_beam_length():
	var points = 3 + level
	beam.clear_points()
	for i in range(points):
		beam.add_point(Vector2(i * 8, 0))

	ray.cast_to = Vector2((points - 1) * 8, 0)

func _process(_delta):
	if Input.is_action_pressed("fire"):
		self.visible = true
		ray.enabled = true
		gun.pixel.visible = false
	else:
		self.visible = false
		ray.enabled = false

func wiggle():
	light.texture_scale = rand_range(.8, 1.3)
	for i in range(beam.points.size()):
		if i == 0:
			continue
		var pos = beam.get_point_position(i)
		beam.set_point_position(i, Vector2(pos.x, rand_range(-3.5, 3.5)))


func _on_Timer_timeout():
	if self.visible:
		wiggle()
 
func _physics_process(_delta):
	var collider = ray.get_collider()
	if collider is RedSwitch:
		collider.open_gate()
	if collider:
		collider.emit_signal("hit", level * .2)


func on_upgrade():
	level = SaverAndLoader.custom_data.zap_ray_level
	set_beam_length()
