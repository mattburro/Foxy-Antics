class_name Player extends CharacterBody2D

enum PLAYER_STATE { IDLE, RUN, JUMP, FALL, HURT }

const GRAVITY: float = 1000.0
const MAX_FALL_SPEED: float = 400.0
const JUMP_VELOCITY: float = -400.0
const RUN_SPEED: float = 120.0
const HURT_TIME: float = 0.3

static var Instance: Player

var state: PLAYER_STATE = PLAYER_STATE.IDLE

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var sound_player = $SoundPlayer
@onready var shooter = $Shooter

func _ready():
	Instance = self

func _process(delta):
	update_debug_text()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_state()
	play_state_animation()

func update_debug_text():
	debug_label.text = "on floor:%s\nstate:%s\nvelocity:%.0f, %.0f" % [
		is_on_floor(),
		PLAYER_STATE.keys()[state],
		velocity.x, velocity.y
	]

func get_input():
	velocity.x = Input.get_axis("left", "right") * RUN_SPEED
	
	if velocity.x != 0:
		sprite_2d.flip_h = velocity.x < 0
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		SoundManager.play_sound(sound_player, SoundManager.SOUND_JUMP)
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL_SPEED)
	
	if Input.is_action_just_pressed("shoot"):
		var shoot_direction = Vector2.RIGHT if not sprite_2d.flip_h else Vector2.LEFT
		shooter.shoot(shoot_direction)

func calculate_state():
	if state == PLAYER_STATE.HURT:
		return
	
	if is_on_floor():
		if velocity.x == 0:
			set_state(PLAYER_STATE.IDLE)
		else:
			set_state(PLAYER_STATE.RUN)
	else:
		if velocity.y > 0:
			set_state(PLAYER_STATE.FALL)
		else:
			set_state(PLAYER_STATE.JUMP)

func set_state(new_state: PLAYER_STATE):
	if new_state == state:
		return
	
	if state == PLAYER_STATE.FALL:
		if new_state == PLAYER_STATE.IDLE or new_state == PLAYER_STATE.RUN:
			SoundManager.play_sound(sound_player, SoundManager.SOUND_LAND)
	
	state = new_state

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

func on_hitbox_area_entered(area: Area2D):
	print("Player hit: ", area.name)
