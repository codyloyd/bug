extends KinematicBody2D

class_name Player

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances

export var move_speed = 28
export var booster_move_speed = 1.5
export var booster_gravity = 4
export var gravity = 18 
export var less_gravity = 8
export var jump_force = 180 
export var max_fall_speed = 140
export var booster_force = 50
var dead = false
export var cutscene_control = false

const DustEffect = preload("res://effects/DustEffect.tscn")
const JumpEffect = preload("res://effects/JumpEffect.tscn")
const ShootEffect = preload("res://effects/ShootEffect.tscn")

var velo = Vector2()
var drag = 0.5
export var booster_drag = .01

const jump_buffer = 0.08
var time_pressed_jump = 0.0
var time_left_ground = 0.0
var last_grounded = false
var facing_right = true
var has_boosted_since_last_ground
var boost_activated = false
var booster_timer_max = 1.5
var booster_timer = booster_timer_max 
var invulnerable = false
var pending_npc_interaction = false
var npc_interaction = false


onready var anim_player = $AnimationPlayer
onready var booster_particles = $BoosterParticles
onready var camera_follower = $RemoteTransform2D

# warning-ignore:unused_signal
signal hit_door(door)

func _ready():
	PlayerStats.bombs_unlocked = SaverAndLoader.custom_data.bombs_unlocked
	PlayerStats.boosters_unlocked = SaverAndLoader.custom_data.boosters_unlocked
	PlayerStats.max_health = SaverAndLoader.custom_data.max_health
	MainInstances.Player = self
	PlayerStats.connect('player_die', self, "die")
	call_deferred("set_camera")
	Events.connect('initiate_npc_interaction', self, 'on_initiate_npc_interaction')
	Events.connect('end_npc_interaction', self, 'on_end_npc_interaction')
	Events.connect('system_access_granted', self, 'on_system_access_granted')

func set_camera():
	camera_follower.remote_path = MainInstances.WorldCamera.get_path()

func queue_free():
	MainInstances.Player = null
	.queue_free()

func _process(_delta):
	if dead: return
	if Input.is_action_just_pressed("save"):
		pass

	if Input.is_action_just_pressed("load"):
		pass

	if Input.is_action_pressed("exit"):
		pass
	
	var tween = get_node("Tween")
	if Input.is_action_pressed("look_down"):
		tween.interpolate_property(camera_follower, "position",
					camera_follower.position, Vector2(0, 20), .2,
					Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()

	if Input.is_action_just_released("look_down"):
		tween.interpolate_property(camera_follower, "position",
					camera_follower.position, Vector2(0, 0), .2,
					Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()


func _physics_process(delta):
	if dead: return
	var was_grounded = is_on_floor()
	var prev_velocity = velo
	var move_vec = Vector2()
	var is_boosting = false

	if cutscene_control:
		if Input.is_action_pressed("control_move_left"):
			move_vec.x -= 1

	if !dead and !cutscene_control:
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1

		if PlayerStats.boosters_unlocked:
			if Input.is_action_just_pressed("jump") and not can_jump():
				boost_activated = true
			is_boosting = boost_activated and Input.is_action_pressed("jump") and not $Ground.is_colliding()

		if is_boosting and booster_timer > 0:
			booster_particles.emitting = true
			has_boosted_since_last_ground = true
			velo.y = -booster_force
		else:
			booster_particles.emitting = false

	if is_boosting:
		booster_timer = max(booster_timer - delta, 0)
		Events.emit_signal("booster_timer_update", booster_timer/booster_timer_max)
	else:
		if booster_timer < booster_timer_max:
			booster_timer += delta * .8
			Events.emit_signal("booster_timer_update", booster_timer/booster_timer_max)

	if $Ground.is_colliding():
		has_boosted_since_last_ground = false
		boost_activated = false

	if has_boosted_since_last_ground:
		velo += move_vec * booster_move_speed - booster_drag * Vector2(velo.x, 0)
	else:
		velo += move_vec * move_speed - drag * Vector2(velo.x, 0)
	

	var cur_grounded = is_on_floor()
	if cur_grounded and not last_grounded and booster_timer != booster_timer_max:
		booster_timer = booster_timer_max
		Events.emit_signal("booster_timer_update", booster_timer/booster_timer_max)

	if !cur_grounded and last_grounded:
		time_left_ground = get_cur_time()
	
	var pressed_jump = Input.is_action_just_pressed("jump")
	
	if pressed_jump:
		time_pressed_jump = get_cur_time()
	
	if (pressed_jump and can_jump()):
		jump()
	
	if Input.is_action_pressed("jump"):
		velo.y += less_gravity
	elif has_boosted_since_last_ground:
		velo.y += booster_gravity
	elif not cur_grounded and not has_boosted_since_last_ground:
		velo.y += gravity

	velo.y = clamp(velo.y, -400, max_fall_speed)
	
	if cur_grounded and velo.y > 36 and not is_boosting:
		velo.y = 30
	

# warning-ignore:return_value_discarded
	move_and_slide_with_snap(velo, Vector2.DOWN*1, Vector2.UP, false, 4, .75, true)
	
	if is_on_ceiling():
		velo.y = 0

	if is_on_wall():
		velo.x = 0

	# $Sprite.scale.x = sign(get_local_mouse_position().x)
	$Sprite.scale.x = sign(get_scaled_position().direction_to(get_viewport_mouse_position()).x)
		
	if cur_grounded and not dead:
		if move_vec == Vector2(0, 0):
			play_anim("idle")
		else:
			play_anim("run")
	elif not $Ground.is_colliding():
		play_anim("jump")
	
	if is_on_floor() and not was_grounded and prev_velocity.y > 30:
		Utils.add_scene_to_main(DustEffect, global_position)

	check_npc_interaction()
	
	last_grounded = cur_grounded

func can_jump():
	if $Ground.is_colliding():
		return true
	elif (!last_grounded and $Ground.is_colliding() and get_cur_time() - time_pressed_jump < jump_buffer):
		return true
	elif get_cur_time() - time_left_ground < jump_buffer:
		return true


func jump():
	if dead or cutscene_control:
		return
	Sfx.play("Jump", rand_range(1.2,1.3), -10)
	velo.y = -jump_force
	Utils.add_scene_to_main(JumpEffect, global_position)

func get_cur_time():
	return OS.get_ticks_msec() / 1000.0

func flip():
	$Sprite.flip_h = !$Sprite.flip_h
	facing_right = !facing_right

func walk_sound():
	Sfx.play("Walk", rand_range(.6, 1.5), -15)

func make_dust():
	Utils.add_scene_to_main(DustEffect, global_position)

func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func on_initiate_npc_interaction():
	pending_npc_interaction = true

func on_end_npc_interaction():
	set_physics_process(true)

func check_npc_interaction():
	if pending_npc_interaction and is_on_floor():
		$AnimationPlayer.play("idle")
		pending_npc_interaction = false
		npc_interaction = true
		set_physics_process(false)


func on_system_access_granted():
	move_speed = 18
	$CutscenePlayer.play('cutscene')

func die():
	anim_player.play("dead")
	dead = true
	Events.emit_signal('screen_shake', 100, 2)
	yield(get_tree().create_timer(2), "timeout")
	Events.emit_signal("black_screen")
	SaverAndLoader.is_loading = true
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func remove_invulnerable():
	invulnerable = false

func take_hit(damage):
	if not invulnerable:
		Sfx.play("Hit2", 1, -4)
		PlayerStats.health -= damage
		$BlinkAnimator.play("blink")
		invulnerable = true
		Events.emit_signal('screen_shake', 1, .7)
		Events.emit_signal('glitch', .015, .2)

func _on_Hurtbox_hit(damage):
	take_hit(damage)


func _on_PowerupDetector_area_entered(pup):
	pup.pickup()

func get_viewport_mouse_position():
	# mouse position within whole view (scaled up with window size)
	return get_viewport().get_mouse_position()

func get_scaled_position():
	#viewport/window ratio
	var windowRatio = OS.get_real_window_size() / get_viewport().size
	# player's coords inside window, scaled.
	return get_global_transform_with_canvas().origin * windowRatio


func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"position_x": position.x,
		"position_y": position.y
	}

	return save_dict

func walk_left():
	Input.action_press("control_move_left")

func stop_moving():
	Input.action_release("control_move_left")
