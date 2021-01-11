extends Area2D

onready var shape = $CollisionShape2D

func _on_CameraSetter_body_entered(body):
	Events.emit_signal("resize_camera", shape.global_position, shape.shape.get_extents())

