extends "res://enemies/Enemy.gd"

export(int) var ACCELLERATION = 150

const BoomEffect = preload("res://effects/BombExplostionEffect.tscn")
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

func _on_PlayerDetector_body_entered(_body):
	Utils.add_scene_to_main(BoomEffect, global_position)
	queue_free()


func _on_SelfDestructTimer_timeout():
	Utils.add_scene_to_main(BoomEffect, global_position)
	queue_free()
