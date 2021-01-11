extends Node2D


func _ready():
	Sfx.play("EnemyDie", rand_range(0.5, 1.3), -18)
	Events.emit_signal('screen_shake', .4, .2)


