extends "res://enemies/Enemy.gd"
var Bullet = preload("res://enemies/BossProjectile.tscn")

onready var level = get_parent()
onready var positions = level.get_node("boss_positions").get_children()
onready var bomb_drop_positions = level.get_node("bomb_drop_pos").get_children()
onready var target_position = positions[0]

var Bomb = preload("res://enemies/BossBomb.tscn")

export(int) var ACCELLERATION = 100

var hit_counter = 1

var Skeet = load("res://enemies/AutoSkeet.tscn")

enum StateMachine{
	ROAMING,
	SPAWNING,
	BOMB_PREP,
	BOMB_DROP
}

var state = StateMachine.ROAMING 

signal boss_died
signal update_health(percentage)

func _ready():
	._ready()

func _physics_process(delta):
	match state:
		StateMachine.ROAMING:
			goto_target(delta)
		StateMachine.SPAWNING:
			$AnimationPlayer.play('spawn')
		StateMachine.BOMB_PREP:
			goto_target(delta)
		StateMachine.BOMB_DROP:
			goto_target(delta)
			#set target, goto target, play bomb drop animation.

func goto_target(delta):
	var dir = (target_position.global_position - global_position).normalized()
	motion += dir * ACCELLERATION * delta
	motion = motion.clamped(MAX_SPEED)

	motion = move_and_slide(motion)


func get_new_target():
	positions.shuffle()
	if positions[0] != target_position:
		target_position = positions[0]
	else: 
		target_position = positions[1]


func _on_Timer_timeout():
	if state == StateMachine.ROAMING:
		get_new_target()

func take_hit(d):
	hit_counter += 1
	if hit_counter % 50 == 0 and state != StateMachine.BOMB_DROP:
		target_position = bomb_drop_positions[0]
		state = StateMachine.BOMB_PREP

	var health_percentage = float(stats.health)/float(stats.max_health)
	emit_signal("update_health", health_percentage)
	$HitPlayer.play("oof")
	.take_hit(d)

func die():
	emit_signal("boss_died")
	queue_free()

func _on_SpawnTimer_timeout():
	if state == StateMachine.ROAMING:
		state = StateMachine.SPAWNING

func spawn_minions():
	var skeet = Skeet.instance()
	skeet.global_position = global_position + Vector2(rand_range(-6,6), rand_range(-6, 6))
	level.add_child(skeet)
	for _i in range(4):
		if randi() % 10 > 6:
			skeet = Skeet.instance()
			skeet.global_position = global_position + Vector2(rand_range(-6,6), rand_range(-6, 6))
			level.add_child(skeet)

	state = StateMachine.ROAMING
	$AnimationPlayer.play("fly")
	get_new_target()

func trigger_bomb_drop():
	if state == StateMachine.BOMB_DROP:
		get_new_target()
		$AnimationPlayer.stop()
		state = StateMachine.ROAMING
		$AnimationPlayer.play("fly")
		MAX_SPEED = 100
	if state == StateMachine.BOMB_PREP:
		state = StateMachine.BOMB_DROP
		target_position = bomb_drop_positions[1]
		$AnimationPlayer.play('drop_bombs')
		MAX_SPEED = 60


func drop_bomb():
	var bomb = Utils.add_scene_to_main(Bomb, global_position)
	bomb.linear_velocity = Vector2(rand_range(-3,3), 0)
