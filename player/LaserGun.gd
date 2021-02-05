extends Node

onready var ray = $RayCast2D
onready var gun = get_parent()
onready var beam = $Line2D
onready var light = $Light2D

var level = 1
var usage_time = 1
var cooldown_timer = usage_time
var can_fire = true
var on = false

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

func turn_off():
	self.visible = false
	ray.enabled = false
	on = false

func turn_on():
	set_process(true)
	on = true

func _process(delta):
	var cooldown_percentage = cooldown_timer/usage_time
	if on and Input.is_action_pressed("fire") and can_fire:
		self.visible = true
		ray.enabled = true
		gun.pixel.visible = false
		cooldown_timer = max(cooldown_timer - delta, 0.001)
		if cooldown_timer <= 0.002:
			can_fire = false
		Events.emit_signal("zap_ray_cooldown_update", cooldown_percentage, can_fire, true)
	else:
		Events.emit_signal("zap_ray_cooldown_update", cooldown_percentage, can_fire, false)
		if cooldown_timer < usage_time:
			cooldown_timer += delta * .3
		if cooldown_timer > .5:
			can_fire = true
		else:
			can_fire = false
		self.visible = false
		ray.enabled = false
		if not on and cooldown_timer >= usage_time:
			set_process(false)

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
	if not ray.enabled:
		return
	var collider = ray.get_collider()
	if collider is RedSwitch:
		collider.open_gate()
	if collider:
		collider.emit_signal("hit", level * .2)


func on_upgrade():
	level = SaverAndLoader.custom_data.zap_ray_level
	set_beam_length()
