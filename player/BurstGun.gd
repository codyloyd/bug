extends Node

const Bullet = preload("res://player/PlayerBullet.tscn")
onready var gun = get_parent()
onready var autofire_timer = $AutofireTimer

var burst_limit = 1
var burst_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SaverAndLoader.connect('game_loaded', self, 'game_loaded')
	Events.connect('gun_upgrade', self, 'on_gun_upgrade')
	set_process(false)


func _process(_delta):
	if not SaverAndLoader.custom_data.gun_unlocked:
		return

	if Input.is_action_just_pressed("fire"):
		burst_counter = 0

	if Input.is_action_pressed("fire"):
		if autofire_timer.is_stopped() and burst_counter < burst_limit:
			fire()


func fire():
	burst_counter += 1
	autofire_timer.start()
	var player = get_parent().get_parent()
	var rotation = gun.rotation
	Sfx.playLaserSound()
	var bullet_position = gun.muzzle.global_position
	var bullet = Utils.add_scene_to_main(Bullet, bullet_position)
	bullet.velocity = (player.get_scaled_position().direction_to(player.get_viewport_mouse_position())).normalized() * 200
	bullet.rotation = rotation 

func game_loaded():
	burst_limit = SaverAndLoader.custom_data.burst_limit

func on_gun_upgrade():
	burst_limit = SaverAndLoader.custom_data.burst_limit