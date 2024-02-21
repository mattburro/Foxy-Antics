class_name Player extends CharacterBody2D

enum PLAYER_STATE { IDLE, RUN, JUMP, FALL, HURT }

const GRAVITY: float = 1000.0
const RUN_SPEED: float = 120.0
const JUMP_VELOCITY: float = -400.0
const MAX_FALL_SPEED: float = 400.0
const HURT_JUMP_VELOCITY: Vector2 = Vector2(0, -150.0)

static var Instance: Player

var state: PLAYER_STATE = PLAYER_STATE.IDLE
var invincible: bool = false

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var animation_player_invincible = $AnimationPlayerInvincible
@onready var debug_label = $DebugLabel
@onready var sound_player = $SoundPlayer
@onready var shooter = $Shooter
@onready var invincible_timer = $InvincibleTimer
@onready var hurt_timer = $HurtTimer

func _ready():
	Instance = self

func _process(_delta):
	update_debug_text()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_state()
	play_state_animation()

func update_debug_text():
	debug_label.text = "floor:%s\ninv:%s\n%s\n%.0f, %.0f" % [
		is_on_floor(),
		invincible,
		PLAYER_STATE.keys()[state],
		velocity.x, velocity.y
	]

func get_input():
	if state == PLAYER_STATE.HURT:
		return
	
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

func apply_hurt_jump():
	set_state(PLAYER_STATE.HURT)
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()
	SignalManager.on_player_hit.emit(0)

func go_invincible():
	invincible = true
	invincible_timer.start()
	animation_player_invincible.play("invincible")

func apply_hit():
	if invincible:
		return
	
	go_invincible()
	apply_hurt_jump()
	SoundManager.play_sound(sound_player, SoundManager.SOUND_DAMAGE)

func on_hitbox_area_entered(area: Area2D):
	apply_hit()

func on_invincible_timer_timeout():
	invincible = false
	animation_player_invincible.stop()

func on_hurt_timer_timeout():
	set_state(PLAYER_STATE.IDLE)
