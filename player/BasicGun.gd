extends Node

const Bullet = preload("res://player/PlayerBullet.tscn")
onready var gun = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)


func _process(delta):
	if Input.is_action_just_pressed('fire'):
		fire()


func fire():
	var player = get_parent().get_parent()
	var rotation = gun.rotation
	Sfx.playLaserSound()
	var bullet_position = gun.muzzle.global_position
	var bullet = Utils.add_scene_to_main(Bullet, bullet_position)
	bullet.velocity = (player.scale * player.get_local_mouse_position()).normalized() * 200
	bullet.rotation = rotation 
