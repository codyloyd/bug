extends StaticBody2D

func _ready():
	$AnimationPlayer.play('INIT')
	if PersistantBricks.is_present(global_position, get_parent().get_path()):
		open()

func open():
	PersistantBricks.save_brick(global_position, get_parent().get_path())
	$AnimationPlayer.play('UP')

