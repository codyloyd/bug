extends "res://levels/Level.gd"

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats

onready var DOOR = $DOOR
onready var boss_meter = $BossMeter/MeterRect
onready var boss = $Boss
onready var boss_trigger = $boss_trigger
onready var spikes = $SPIKES
onready var token = $TOKEN

func _ready():
	if SaverAndLoader.custom_data.boss1_defeated:
		boss.queue_free()
		boss_meter.queue_free()
		$boss_trigger.queue_free()
		DOOR.visible = false
		spikes.queue_free()
		token.visible = true
		if not Music.list_index == 4:
			Music.list_index = 4
			Music.play_music()
	else:
		Music.play_boss_music()

func _on_Boss_boss_died():
	var player = MainInstances.Player
	player.set_process(false)
	player.set_physics_process(false)
	SaverAndLoader.custom_data.boss1_defeated = true
	SaverAndLoader.save_custom_data()
	SaverAndLoader.save_game()
	boss_trigger.queue_free()
	boss_meter.queue_free()
	DOOR.set_collision_layer_bit(1, false)
	DOOR.visible = false
	Music.stop_music()
	Sfx.play("GlitchEnd", 1, 0)
	Events.emit_signal("screen_shake", .2, 6)
	Events.emit_signal("glitch", .03, 5)
	PlayerStats.health = PlayerStats.max_health
	yield(get_tree().create_timer(4), 'timeout')
	get_tree().change_scene("res://game-screens/FIRST_BOSS_DEFEAT.tscn")


func _on_boss_trigger_body_entered(_body):
	DOOR.set_collision_layer_bit(1, true)
	DOOR.visible = true

func _on_Boss_update_health(percentage):
	boss_meter.rect_scale.x = percentage
