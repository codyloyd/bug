extends Node2D

var target_coords = null

onready var follower = $Path2D/PathFollow2D/RemoteTransform2D
onready var skeet = $Skeet

func _ready():
	$AnimationPlayer.playback_speed = rand_range(.2, .5)


func _on_Area2D_body_entered(Player):
	target_coords = Player.global_position
	global_position = skeet.global_position
	follower.use_global_coordinates = false
	skeet.set_physics_process(true)
