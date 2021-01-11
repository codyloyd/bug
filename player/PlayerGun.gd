extends Node2D

onready var pixel = $Pixel
onready var muzzle = $Muzzle

const Bullet = preload("res://player/PlayerBullet.tscn")

func _ready():
	$BurstGun.set_process(true)
	Events.connect('select_weapon', self, 'on_select_weapon')
	pass

func _process(_delta):
	if not SaverAndLoader.custom_data.gun_unlocked:
		pixel.visible = false
	else:
		pixel.visible = true

	var player = get_parent()

	rotation = player.get_scaled_position().direction_to(player.get_viewport_mouse_position()).angle()

	pixel.rect_rotation = -rad2deg(rotation)

	if Input.is_key_pressed(KEY_1):
		if SaverAndLoader.custom_data.gun_unlocked:
			Events.emit_signal('select_weapon', 'burst_gun')

	if Input.is_key_pressed(KEY_2):
		if SaverAndLoader.custom_data.bombs_unlocked:
			Events.emit_signal('select_weapon', 'bomb_gun')

	if Input.is_key_pressed(KEY_3):
		if SaverAndLoader.custom_data.zap_ray_unlocked:
			Events.emit_signal('select_weapon', 'zap_ray')

func on_select_weapon(weapon):
	if weapon == 'burst_gun' && SaverAndLoader.custom_data.gun_unlocked:
		$BombGun.set_process(false)
		$BurstGun.set_process(true)
		$ZapRay.set_process(false)

	if weapon == 'bomb_gun' && SaverAndLoader.custom_data.bombs_unlocked:
		$BombGun.set_process(true)
		$BurstGun.set_process(false)
		$ZapRay.set_process(false)

	if weapon == 'zap_ray' && SaverAndLoader.custom_data.zap_ray_unlocked:
		$BombGun.set_process(false)
		$BurstGun.set_process(false)
		$ZapRay.set_process(true)