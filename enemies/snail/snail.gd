extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var floor_detection = $FloorDetection

func _ready():
	pass

func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_on_floor():
		velocity.y = gravity * delta
	else:
		velocity.x = speed * facing
	
	move_and_slide()
	
	if is_on_floor():
		if is_on_wall() or not floor_detection.is_colliding():
			flip()

func flip():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	floor_detection.position.x *= -1
	
	if facing == FACING.LEFT:
		facing = FACING.RIGHT
	else:
		facing = FACING.LEFT
