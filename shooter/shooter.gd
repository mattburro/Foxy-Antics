extends Node2D

@export var speed: float = 50.0
@export var life_span: float = 20.0
@export var bullet_key: ObjectMaker.BULLET_KEY
@export var shoot_delay: float = 0.7

var can_shoot: bool = true

@onready var sound = $Sound
@onready var shoot_timer = $ShootTimer

func _ready():
	shoot_timer.wait_time = shoot_delay

func shoot(direction: Vector2):
	if not can_shoot:
		return
	
	can_shoot = false
	SoundManager.play_sound(sound, SoundManager.SOUND_LASER)
	ObjectMaker.create_bullet(bullet_key, global_position, direction, speed, life_span)
	shoot_timer.start()

func on_shoot_timer_timeout():
	can_shoot = true
