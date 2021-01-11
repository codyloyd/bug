extends StaticBody2D

export(NodePath) var gate = null

func _on_Area2D_body_entered(_body):
	$AnimationPlayer.play('press')
	get_node(gate).open()
