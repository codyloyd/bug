extends "res://levels/Level.gd"

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats

onready var DOOR = $DOOR
onready var boss_meter = $BossMeter/MeterRect
onready var boss = $BOSS3
onready var boss_trigger = $boss_trigger

func _ready():
	boss.set_physics_process(false)
	if SaverAndLoader.custom_data.boss3_defeated:
		boss.queue_free()
		boss_meter.queue_free()
		$boss_trigger.queue_free()
		DOOR.visible = false
		$TOKEN.visible = true
	else:
		pass

func _on_BOSS3_update_health(percentage):
	boss_meter.rect_scale.x = percentage

func _on_boss_trigger_body_entered(_body):
	Music.play_boss_music()
	boss.set_physics_process(true)
	DOOR.set_collision_layer_bit(1, true)
	DOOR.visible = true
	$boss_trigger.queue_free()

func _on_BOSS3_boss_died():
	var player = MainInstances.Player
	player.set_process(false)
	player.set_physics_process(false)
	$TOKEN.visible = true
	SaverAndLoader.custom_data.boss3_defeated = true
	SaverAndLoader.save_custom_data()
	boss_meter.queue_free()
	DOOR.set_collision_layer_bit(1, false)
	DOOR.visible = false
	Music.stop_music()
	Sfx.play("GlitchEnd", 1, 0)
	Events.emit_signal("screen_shake", .2, 3)
	Events.emit_signal("glitch", .03, 2)
	if SaverAndLoader.custom_data.boss2_defeated:
		Music.list_index = 1
		Music.play_music()
	else:
		Music.list_index = 5
		Music.play_music()
	PlayerStats.health = PlayerStats.max_health
	yield(get_tree().create_timer(2), 'timeout')
	player.set_process(true)
	player.set_physics_process(true)


func _on_BombDropTrigger_body_entered(body):
	body.trigger_bomb_drop()
