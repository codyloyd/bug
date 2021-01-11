extends ColorRect

const ExplosionEffect = preload("res://effects/BIGBOOM.tscn")

func _ready():
	Events.emit_signal("clear_screen")

func BOOM():
	var main = get_tree().current_scene
	var instance = ExplosionEffect.instance()
	main.call_deferred("add_child", instance)
	instance.global_position = Vector2(114, 68)
	yield(get_tree().create_timer(4), "timeout")
	to_start()

func to_start():
	get_tree().change_scene("res://menus/StartMenu.tscn")
