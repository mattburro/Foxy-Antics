class_name Player extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

const GRAVITY: float = 1000.0
const MAX_FALL_SPEED: float = 400.0
const JUMP_VELOCITY: float = -400.0
const RUN_SPEED: float = 120.0
const HURT_TIME: float = 0.3

enum PLAYER_STATE { IDLE, RUN, JUMP, FALL, HURT }

var state: PLAYER_STATE = PLAYER_STATE.IDLE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_state()
	play_state_animation()

func get_input():
	velocity.x = Input.get_axis("left", "right") * RUN_SPEED
	
	if velocity.x != 0:
		sprite_2d.flip_h = velocity.x < 0
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)

func calculate_state():
	if state == PLAYER_STATE.HURT:
		return
	
	if is_on_floor():
		if velocity.x == 0:
			state = PLAYER_STATE.IDLE
		else:
			state = PLAYER_STATE.RUN
	else:
		if velocity.y > 0:
			state = PLAYER_STATE.FALL
		else:
			state = PLAYER_STATE.JUMP

func play_state_animation():
	match state:
		PLAYER_STATE.IDLE:
			animation_player.play("idle")
		PLAYER_STATE.RUN:
			animation_player.play("run")
		PLAYER_STATE.JUMP:
			animation_player.play("jump")
		PLAYER_STATE.FALL:
			animation_player.play("fall")
		PLAYER_STATE.HURT:
			animation_player.play("hurt")
