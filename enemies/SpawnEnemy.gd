extends "res://enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var FLY_DIRECTION = DIRECTION.LEFT

onready var sprite = $Sprite
onready var level = get_parent()

func _process(delta):
	check_position()

func _physics_process(_delta):
	check_position()
	match FLY_DIRECTION:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED

	sprite.scale.x = sign(motion.x)
	motion = move_and_slide(motion, Vector2.DOWN)

func check_position():
	var map_rect = level.tile_map.get_used_rect()
	var cell = level.tile_map.cell_size
	var limit_right = map_rect.end.x * cell.x + level.global_position.x
	var limit_left = map_rect.position.x * cell.x + level.global_position.x
	if global_position.x < limit_left or global_position.x > limit_right:
		queue_free()
