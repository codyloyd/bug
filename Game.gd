extends Node2D

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats
var level_00 = load('res://levels/Level_00.tscn')
onready var current_level = null
onready var level_change_timer = $LevelChangeTimer
onready var viewport = $ViewportContainer/Viewport

var is_changing_levels = false
var prev_level

onready var camera = MainInstances.WorldCamera

func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	VisualServer.set_default_clear_color(Color('#0e0c0f'))
	Events.connect("resize_camera", self, "on_resize_camera")

	if SaverAndLoader.is_loading:
		SaverAndLoader.load_game()
		SaverAndLoader.is_loading = false
		Music.list_index = SaverAndLoader.custom_data.music_list_index
		Music.play_music()
		Sfx.play('Buzz')
		PlayerStats.health = PlayerStats.max_health
		PersistantBricks.bricks = SaverAndLoader.custom_data.bricks
		current_level.activateDoors()
	else:
		current_level = level_00.instance()
		current_level.path = level_00.get_path()
		if current_level.get_node("PlayerSpawn"):
			MainInstances.Player.global_position = current_level.get_node("PlayerSpawn").global_position
		viewport.add_child(current_level)
		current_level.activateDoors()
		SaverAndLoader.call_deferred("save_game")

	call_deferred("set_camera_limits", current_level)
	MainInstances.Player.connect('hit_door', self, "_on_Player_hit_door")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pass
			# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Player_hit_door(door):
	call_deferred("change_level", door)


func change_level(door):
	level_change_timer.start()


	current_level.deactivateDoors()
	var stash_current_level = current_level
	viewport.remove_child(current_level)


	var NewLevel = load(door.next_level)
	var newLevel = NewLevel.instance()
	newLevel.path = NewLevel.get_path()

	if prev_level and newLevel.path == prev_level.path:
		newLevel = prev_level
		current_level = newLevel

	prev_level = stash_current_level

	viewport.add_child(newLevel)
	var newDoor = get_next_door(door)
	MainInstances.Player.global_position = newDoor.spawn_point.global_position
	call_deferred("set_camera_limits", newLevel)
	yield(get_tree().create_timer(.05), "timeout")
	newLevel.activateDoors()

func set_camera_limits(level):
	var camera = MainInstances.WorldCamera
	var map_rect = level.tile_map.get_used_rect()
	var cell = current_level.tile_map.cell_size
	camera.smoothing_enabled = false
	camera.limit_top = map_rect.position.y * cell.y + 10 + level.global_position.y
	camera.limit_right = map_rect.end.x * cell.x + level.global_position.x
	camera.limit_bottom = map_rect.end.y * cell.y + 10 + level.global_position.y
	camera.limit_left = map_rect.position.x * cell.x + level.global_position.x

func on_resize_camera(center_position, extents):
	camera.smoothing_enabled = true

	var tweenTime = 1
	if not level_change_timer.is_stopped():
		tweenTime = 0
		camera.smoothing_enabled = false

	var new_limit_top = center_position.y - extents.y + 10 
	camera.tween.interpolate_property(camera, "limit_top", camera.limit_top, new_limit_top, tweenTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	var new_limit_bottom = center_position.y + extents.y + 10
	camera.tween.interpolate_property(camera, "limit_bottom", camera.limit_bottom, new_limit_bottom, tweenTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	camera.tween.start()

func get_next_door(oldDoor):
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		if door != oldDoor and door.connection == oldDoor.connection:
			return door

	return null
