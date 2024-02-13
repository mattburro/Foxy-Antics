extends Area2D

const GRAVITY: float = 150.0
const JUMP: float = -80.0
const POINTS: int = 2

var start_y: float
var speed_y: float = JUMP
var stopped: bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	start_y = global_position.y
	play_random_animation()

func _process(delta):
	if stopped:
		return
	
	position.y += speed_y * delta
	speed_y += GRAVITY * delta
	
	if global_position.y > start_y:
		stopped = true

func play_random_animation():
	var animations: Array = animated_sprite_2d.sprite_frames.get_animation_names()
	animated_sprite_2d.play(animations.pick_random())

func kill_me():
	set_process(false)
	hide()
	queue_free()

func on_life_timer_timeout():
	kill_me()

func on_area_entered(area: Area2D):
	SignalManager.on_pickup_hit.emit(POINTS)
	kill_me()
