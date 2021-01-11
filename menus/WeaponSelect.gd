extends Control

onready var weapon_name = $WeaponName
onready var weapon_desc = $WeaponDesc
onready var blaster_button = $HBoxContainer/BlasterButton
onready var bomb_button = $HBoxContainer/BombButton
onready var zap_ray_button = $HBoxContainer/ZapRayButton

func _ready():
	visible = false
	Events.connect('game_paused', self, 'on_game_paused')

func _process(_delta):
	if Input.is_action_just_pressed("weapon_select"):
		toggle_visible()

func toggle_visible():
	if not SaverAndLoader.custom_data.bombs_unlocked:
		return

	visible = !visible
	get_tree().paused = visible

	if SaverAndLoader.custom_data.bombs_unlocked:
		bomb_button.visible = true

	if SaverAndLoader.custom_data.zap_ray_unlocked:
		zap_ray_button.visible = true

func _on_BlasterButton_mouse_entered():
	weapon_name.text = "blaster"
	weapon_desc.text = "move mouse to aim, click to fire\nhotkey: 1"

func _on_BombButton_mouse_entered():
	weapon_name.text = "bomb"
	weapon_desc.text = "click to set bomb, then run away!\nhotkey: 2"

func _on_ZapRayButton_mouse_entered():
	weapon_name.text = "zap ray"
	weapon_desc.text = "hold left mouse button, move mouse to aim\nhotkey: 3"

func _on_BlasterButton_pressed():
	Events.emit_signal('select_weapon', 'burst_gun')
	toggle_visible()

func _on_BombButton_pressed():
	Events.emit_signal('select_weapon', 'bomb_gun')
	toggle_visible()

func _on_ZapRayButton_pressed():
	Events.emit_signal('select_weapon', 'zap_ray')
	toggle_visible()

func on_game_paused():
	visible = false
