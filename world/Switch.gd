extends Area2D
class_name Switch

export(NodePath) var gate_path = null

func open_gate():
	$AnimationPlayer.stop()
	var gate = get_node(gate_path)
	if gate:
		Sfx.play("Gate")
		gate.queue_free()
