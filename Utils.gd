extends Node


func add_scene_to_main(scene, position):
	var main = get_tree().current_scene.current_level
	var instance = scene.instance()
	main.call_deferred("add_child", instance)
	instance.global_position = position
	return instance
