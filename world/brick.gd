extends StaticBody2D


onready var parent = get_parent().get_path()

func _ready():
	pass


func destroy():
	PersistantBricks.save_brick(global_position, parent)
	queue_free()