extends "res://levels/Level.gd"

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats

onready var DOOR = $DOOR
onready var boss_meter = $BossMeter/MeterRect
onready var boss = $BOSS2
onready var boss_trigger = $boss_trigger

func _ready():
	$MusicTrigger.set_collision_layer_bit(1, false)
	$MusicTrigger2.set_collision_layer_bit(1, false)
	if SaverAndLoader.custom_data.boss2_defeated:
		boss.queue_free()
		boss_meter.queue_free()
		$boss_trigger.queue_free()
		DOOR.visible = false
		$TOKEN.visible = true
		$ZapGate.queue_free()
		$ZapGate2.queue_free()
	else:
		Music.play_boss_music()

func _on_BOSS2_update_health(percentage):
	boss_meter.rect_scale.x = percentage

func _on_boss_trigger_body_entered(_body):
	DOOR.set_collision_layer_bit(1, true)
	DOOR.visible = true

func _on_BOSS2_boss_died():
	var player = MainInstances.Player
	player.set_process(false)
	player.set_physics_process(false)
	$MusicTrigger.set_collision_layer_bit(1, true)
	$MusicTrigger2.set_collision_layer_bit(1, true)
	Music.list_index = 3
	Music.play_music()
	$TOKEN.visible = true
	SaverAndLoader.custom_data.boss2_defeated = true
	SaverAndLoader.save_custom_data()
	boss_trigger.queue_free()
	boss_meter.queue_free()
	DOOR.set_collision_layer_bit(1, false)
	DOOR.visible = false
	Music.stop_music()
	Sfx.play("GlitchEnd", 1, 0)
	Events.emit_signal("screen_shake", .2, 3)
	Events.emit_signal("glitch", .03, 3)
	$ZapGate.queue_free()
	$ZapGate2.queue_free()
	PlayerStats.health = PlayerStats.max_health
	yield(get_tree().create_timer(2), 'timeout')
	player.set_process(true)
	player.set_physics_process(true)

func _on_MusicTrigger_body_entered(_body):
	if SaverAndLoader.custom_data.boss3_defeated:
		Music.list_index = 1
		Music.play_music()
	else:
		Music.list_index = 4
		Music.play_music()
	$MusicTrigger.set_collision_layer_bit(1, false)
	$MusicTrigger2.set_collision_layer_bit(1, false)
