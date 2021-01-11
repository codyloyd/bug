extends Area2D


export(Resource) var connection = null
export(String, FILE, "*.tscn") var next_level = ""

var active = false

onready var spawn_point = $Position2D

func _on_Door_body_entered(Player):
	if active:
		Player.emit_signal("hit_door", self)
		active = false
