extends Node


const Bomb = preload("res://player/bomb.tscn")
onready var gun = get_parent()

func _ready():
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed('fire'):
		set_bomb()

func set_bomb():
	Utils.add_scene_to_main(Bomb, gun.global_position)
