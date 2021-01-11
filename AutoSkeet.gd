extends "res://enemies/Enemy.gd"

export(int) var ACCELLERATION = 150

var MainInstances = ResourceLoader.MainInstances

func _physics_process(delta):
	var player = MainInstances.Player
	if player:
		chase_player(player, delta)


func chase_player(player, delta):
	var dir = (player.global_position - global_position).normalized()
	motion += dir * ACCELLERATION * delta
	motion = motion.clamped(MAX_SPEED)

	$Sprite.flip_h = !(player.global_position > global_position)
	
	motion = move_and_slide(motion)