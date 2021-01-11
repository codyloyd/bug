extends Node2D

const GAME = preload("res://Game.gd")
onready var tile_map = $TileMap
var path = ""

func _ready():
	var parent = get_tree().get_root().get_node("Game")
	if parent is GAME:
		parent.current_level = self
	call_deferred("bricks")
	call_deferred("clear_screen")

func clear_screen():
	yield(get_tree().create_timer(1), "timeout")
	Events.emit_signal("clear_screen")

func activateDoors():
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		door.active = true

func deactivateDoors():
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		door.active = false

func bricks():
	var bricks = get_tree().get_nodes_in_group('brick')
	for b in bricks:
		if PersistantBricks.is_present(b.global_position, self.get_path()):
			b.queue_free()

func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"position_x": position.x,
		"position_y": position.y
	}
	return save_dict
