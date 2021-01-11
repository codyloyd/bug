extends "res://enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}
export(DIRECTION) var WALKING_DIRECTION = DIRECTION.LEFT

var Head = preload("res://enemies/FlyingTallHead.tscn")

onready var left_floor = $LeftFloor
onready var right_floor = $RightFloor
onready var left_wall = $LeftWall
onready var right_wall = $RightWall
onready var sprite = $Sprite
onready var headpos = $headpos

var state

func _ready():
	state = WALKING_DIRECTION
	

func _physics_process(_delta):
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if not right_floor.is_colliding() or right_wall.is_colliding():
				state = DIRECTION.LEFT
			
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if not left_floor.is_colliding() or left_wall.is_colliding():
				state = DIRECTION.RIGHT
					

	sprite.scale.x = sign(-motion.x)
	motion = move_and_slide_with_snap(motion, Vector2.DOWN*2, Vector2.UP, false, 4, .75)

func die():
	Utils.add_scene_to_main(Head, headpos.global_position)
	.die()
