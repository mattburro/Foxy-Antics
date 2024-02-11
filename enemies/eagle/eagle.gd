extends EnemyBase

const FLY_SPEED: Vector2 = Vector2(-35, 15)

var fly_direction: Vector2 = Vector2.ZERO

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_detector = $PlayerDetector
@onready var turn_timer = $TurnTimer
@onready var shooter = $Shooter

func _physics_process(delta):
	super._physics_process(delta)
	
	move_and_slide()
	check_shoot()

func fly_to_player():
	check_flip()
	
	velocity = FLY_SPEED
	
	if animated_sprite_2d.flip_h:
		velocity.x *= -1
	
	turn_timer.start()

func check_shoot():
	if player_detector.is_colliding():
		var shoot_direction = global_position.direction_to(player_ref.global_position)
		shooter.shoot(shoot_direction)

func check_flip():
	var direction = sign(player_ref.global_position.x - global_position.x)
	animated_sprite_2d.flip_h = direction > 0

func on_screen_entered():
	fly_to_player()

func on_turn_timer_timeout():
	fly_to_player()
