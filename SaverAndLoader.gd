extends Node

var custom_data = {
	boss1_defeated = false,
	boss2_defeated = false,
	boss3_defeated = false,
	met_the_system = false,
	gun_unlocked = false,
	burst_limit = 1,
	boosters_unlocked = false,
	bombs_unlocked = false,
	zap_ray_unlocked = false,
	zap_ray_level = 1,
	max_health = 4,
	bricks = [],
	music_list_index = 1
}

# var custom_data = {
# 	boss1_defeated = true,
# 	boss2_defeated = false,
# 	boss3_defeated = false,
# 	miniboss_1_defeated = false,
# 	met_the_system = false,
# 	gun_unlocked = true,
# 	burst_limit = 7,
# 	boosters_unlocked = true,
# 	bombs_unlocked = true,
# 	zap_ray_unlocked = true,
# 	zap_ray_level = 2,
# 	max_health = 8,
# 	bricks = [],
# 	music_list_index = 1
# }

var is_loading = false

signal game_loaded

func save_file_exists():
	var save_game = File.new()
	return save_game.file_exists("user://savegame.save")

func save_custom_data():
	var save_game = File.new()
	save_game.open("user://savegame_custom_data.save", File.WRITE)
	save_game.store_line(to_json(custom_data))
	save_game.close()

func load_custom_data():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame_custom_data.save"):
		return
	
	save_game.open("user://savegame_custom_data.save", File.READ)

	if not save_game.eof_reached():
		custom_data = parse_json(save_game.get_line())

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)

	save_custom_data()

	var persistingNodes = get_tree().get_nodes_in_group("Persists")
	for node in persistingNodes:
		var node_data = node.save()
		save_game.store_line(to_json(node_data))
	save_game.close()


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	
	var persistingNodes = get_tree().get_nodes_in_group("Persists")
	for node in persistingNodes:
		node.queue_free()
	
	save_game.open("user://savegame.save", File.READ)

	load_custom_data()

	while not save_game.eof_reached():
		var line_string = save_game.get_line()
		if line_string != "":
			var current_line = parse_json(line_string)
			if current_line:
				var newNode = load(current_line["filename"]).instance()
				get_node(current_line["parent"]).add_child(newNode, true)
				newNode.position = Vector2(current_line["position_x"], current_line["position_y"])
				for property in current_line.keys():
					if (property == "filename"
						or property == "parent"
						or property == "position_x"
						or property == "position_y"):
						continue

					newNode.set(property, current_line[property])

	save_game.close()

	emit_signal('game_loaded')

func all_bosses_defeated():
	return custom_data.boss1_defeated and custom_data.boss2_defeated and custom_data.boss3_defeated
