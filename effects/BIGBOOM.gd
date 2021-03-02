extends Node2D


func bang():
	Music.stop_music()
	Sfx.play("EnemyDie", 1.2, -10)
	Sfx.play("EnemyDie", .3, -10)
	Sfx.play("Hit3", .8, -8)
	Sfx.play("Hit2", 1, -8)
