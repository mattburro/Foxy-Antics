extends EnemyBase

const JUMP_VELOCITY: Vector2 = Vector2(-100, -200)
const JUMP_WAIT_RANGE: Array = [2.5, 5.0]

var can_jump: bool = false
var seen_player: bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_timer = $JumpTimer

func _ready():
	super._ready()
	start_jump_timer()

func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	apply_jump()
	move_and_slide()
	check_flip()

func apply_jump():
	if not can_jump or not is_on_floor() or not seen_player:
		return
	
	velocity = JUMP_VELOCITY
	
	if animated_sprite_2d.flip_h:
		velocity.x *= -1
	
	can_jump = false
	animated_sprite_2d.play("jump")
	start_jump_timer()

func check_flip():
	animated_sprite_2d.flip_h = player_ref.global_position.x > global_position.x

func start_jump_timer():
	jump_timer.start(randf_range(JUMP_WAIT_RANGE[0], JUMP_WAIT_RANGE[1]))

func on_jump_timer_timeout():
	can_jump = true

func on_screen_entered():
	seen_player = true

func on_screen_exited():
	seen_player = false
