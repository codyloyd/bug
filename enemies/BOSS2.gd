extends "res://enemies/Enemy.gd"

var Bullet = preload("res://enemies/BossProjectile.tscn")

onready var level = get_parent()
onready var positions = level.get_node("RandomBossPositions").get_children()
onready var spin_pos = level.get_node("SpinPosition")
onready var target_position = positions[0]
onready var muzzle1 = $Sprite2/muzzle
onready var muzzle2 = $Sprite2/muzzle2
export(int) var ACCELLERATION = 100

enum StateMachine{
	ROAMING,
	SPIN_FIRE,
	LASER
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
		StateMachine.SPIN_FIRE:
			if not $SpinTimer.time_left:
				$SpinTimer.start()
			goto_spin(delta)

func goto_target(delta):
	var dir = (target_position.global_position - global_position).normalized()
	motion += dir * ACCELLERATION * delta
	motion = motion.clamped(MAX_SPEED)

	motion = move_and_slide(motion)

func goto_spin(delta):
	var dir_raw = (spin_pos.global_position - global_position)
	var dir = dir_raw.normalized()
	motion += dir * 500 * delta
	motion = motion.clamped(MAX_SPEED)

	motion = move_and_slide(motion)


func get_new_target():
	positions.shuffle()
	if positions[0] != target_position:
		target_position = positions[0]
	else: 
		target_position = positions[1]


func _on_Timer_timeout():
	get_new_target()

func take_hit(d):
	var health_percentage = float(stats.health)/float(stats.max_health)
	var health_int = int(health_percentage*100)
	if health_int == 80:
		state = StateMachine.SPIN_FIRE
	if health_percentage < .3:
		state = StateMachine.ROAMING
		$Laser.turn_on()

	emit_signal("update_health", health_percentage)
	$HitPlayer.play("oof")
	.take_hit(d)

func die():
	emit_signal("boss_died")
	queue_free()

func shoot():
	var bullet = Utils.add_scene_to_main(Bullet, muzzle1.global_position)
	var bullet2 = Utils.add_scene_to_main(Bullet, muzzle2.global_position)
	var velocity1 = Vector2.RIGHT * 70
	velocity1 = velocity1.rotated($Sprite2.rotation)
	bullet.velocity = velocity1
	var velocity2 = Vector2.LEFT * 70
	velocity2 = velocity2.rotated($Sprite2.rotation)
	bullet2.velocity = velocity2

func start_shooting():
	if not $ShootTimer.time_left:
		$ShootTimer.start()

func _on_SpinTimer_timeout():
	$AnimationPlayer.play("shoot")

func _on_ShootTimer_timeout():
	$AnimationPlayer.play("float")
	state = StateMachine.ROAMING
