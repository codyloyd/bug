extends Control

onready var icons = get_children()

func _ready():
	Events.connect('select_weapon', self, "select_weapon")

func select_weapon(weapon):
	for i in icons:
		i.visible = false
	match weapon:
		"burst_gun":
			$BurstIcon.visible = true
		"zap_ray":
			$LaserIcon.visible = true
		"bomb_gun":
			$BombIcon.visible = true