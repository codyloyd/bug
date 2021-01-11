extends Node

var bricks = []

func is_present(pos, parent):
	return bricks.has(str(pos, parent))

func save_brick(pos, parent):
	if not is_present(pos, parent):
		bricks.append(str(pos, parent))
		SaverAndLoader.custom_data.bricks = bricks
		SaverAndLoader.save_custom_data()
