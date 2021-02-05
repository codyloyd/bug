extends "res://levels/Level.gd"

onready var trigger = $DoorTrigger
onready var doors = $DOORS
onready var boss1 = $WallBoss1
onready var boss2 = $WallBoss2
onready var boss3 = $WallBoss3

var boss1_dead = false
var boss2_dead = false
var boss3_dead = false

func _ready():
	if SaverAndLoader.custom_data.miniboss_1_defeated:
		boss1.queue_free()
		boss2.queue_free()
		boss3.queue_free()
		trigger.queue_free()
		doors.visible = false
		doors.set_collision_layer_bit(1, false)

func _on_DoorTrigger_body_entered(_body):
	doors.visible = true
	doors.set_collision_layer_bit(1, true)
	trigger.queue_free()

func check_win():
	if are_bosses_dead():
		doors.visible = false
		doors.set_collision_layer_bit(1, false)
		SaverAndLoader.custom_data.miniboss_1_defeated = true
		SaverAndLoader.save_custom_data()

func are_bosses_dead():
	return boss1_dead and boss2_dead and boss3_dead

func _on_WallBoss1_boss_died():
	boss1_dead = true
	check_win()

func _on_WallBoss2_boss_died():
	boss2_dead = true
	check_win()

func _on_WallBoss3_boss_died():
	boss3_dead = true
	check_win()
