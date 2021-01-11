extends "res://enemies/Enemy.gd"

const Bullet = preload("res://player/EnemyBullet.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}
export(DIRECTION) var WALKING_DIRECTION = DIRECTION.LEFT
var state = null

onready var sprite = $Sprite
onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight

func _ready():
	state = WALKING_DIRECTION


func _physics_process(_delta):
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			$AnimationPlayer.play("ROLL_RIGHT")
			if not floorRight.is_colliding() or wallRight.is_colliding():
				state = DIRECTION.LEFT
			
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			$AnimationPlayer.play("ROLL")
			if not floorLeft.is_colliding() or wallLeft.is_colliding():
				state = DIRECTION.RIGHT
					

	sprite.scale.x = sign(-motion.x)
	motion = move_and_slide_with_snap(motion, Vector2.DOWN*2, Vector2.UP, false, 4, .75)


func _on_Area2D_body_entered(Player):
	var player_direction = (Player.global_position - $Muzzle.global_position).normalized()
	if player_direction.x > 0:
		state = DIRECTION.RIGHT
	else:
		state = DIRECTION.LEFT

	var bullet_position = $Muzzle.global_position
	var bullet = Utils.add_scene_to_main(Bullet, bullet_position)
	bullet.velocity = player_direction * 50 
	bullet.rotation = player_direction.angle()
