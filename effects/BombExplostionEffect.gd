extends Node2D

const BREAKABLE_BIT = 5


func _ready():
	Sfx.play("EnemyDie", 1.6, -10)
	Sfx.play("Hit3", 1, -8)
	Events.emit_signal('screen_shake', 10, .3)


func _on_Hitbox_body_entered(body):
	if body.get_collision_layer_bit(BREAKABLE_BIT):
		body.destroy()