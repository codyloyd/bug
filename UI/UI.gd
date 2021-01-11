extends CanvasLayer


func _ready():
	Events.connect('black_screen', self, "GoBlack")
	Events.connect('clear_screen', self, "GoClear")
	Events.connect('gun_unlocked', self, "show_weapon_icon")
	SaverAndLoader.connect('game_loaded', self, 'game_loaded')

func GoBlack():
	$BlackScreen.visible = true

func GoClear():
	$BlackScreen.visible = false

func show_weapon_icon():
	$WeaponIcon.visible = true

func game_loaded():
	if SaverAndLoader.custom_data.gun_unlocked:
		show_weapon_icon()