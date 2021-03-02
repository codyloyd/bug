extends Node2D

onready var pixel = $Pixel
onready var muzzle = $Muzzle
onready var debouncer = $ScrollWheelDebouncer

const Bullet = preload("res://player/PlayerBullet.tscn")
var current_weapon = 0 
var weapons = ['burst_gun']

func _ready():
	$BurstGun.set_process(true)
	if SaverAndLoader.custom_data.bombs_unlocked:
		weapons.append('bomb_gun')
	if SaverAndLoader.custom_data.zap_ray_unlocked:
		weapons.append('zap_ray')

	Events.connect('select_weapon', self, 'on_select_weapon')
	Events.connect('bombs_activated', self, 'on_activate_bombs')
	Events.connect('zap_ray_activated', self, 'on_activate_zap_ray')
	Events.connect('initiate_npc_interaction', self, "disable_gun")
	Events.connect('end_npc_interaction', self, "enable_gun")
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if debouncer.is_stopped():
			if event.button_index == BUTTON_WHEEL_UP:
				next_weapon()
			if event.button_index == BUTTON_WHEEL_DOWN:
				prev_weapon()

func next_weapon():
	debouncer.start()
	current_weapon = (current_weapon + 1) % weapons.size()
	Events.emit_signal('select_weapon', weapons[current_weapon])

func prev_weapon():
	debouncer.start()
	current_weapon = (current_weapon - 1) % weapons.size()
	Events.emit_signal('select_weapon', weapons[current_weapon])


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
		$ZapRay.turn_off()

	if weapon == 'bomb_gun' && SaverAndLoader.custom_data.bombs_unlocked:
		$BombGun.set_process(true)
		$BurstGun.set_process(false)
		$ZapRay.turn_off()

	if weapon == 'zap_ray' && SaverAndLoader.custom_data.zap_ray_unlocked:
		$BombGun.set_process(false)
		$BurstGun.set_process(false)
		$ZapRay.turn_on()

func on_activate_bombs():
	weapons.append('bomb_gun')
	Events.emit_signal('select_weapon', 'bomb_gun')

func on_activate_zap_ray():
	weapons.append('zap_ray')
	Events.emit_signal('select_weapon', 'zap_ray')


func disable_gun():
	set_process(false)
	$BombGun.set_process(false)
	$BurstGun.set_process(false)
	$ZapRay.turn_off()
	pixel.visible = false

func enable_gun():
	Events.emit_signal('select_weapon', 'burst_gun')
	set_process(true)