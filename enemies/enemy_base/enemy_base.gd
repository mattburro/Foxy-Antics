class_name EnemyBase extends CharacterBody2D

enum FACING { LEFT = -1, RIGHT = 1 }

const OFF_SCREEN_KILL_ME: float = 1000.0

@export var default_facing: FACING = FACING.LEFT
@export var points: int = 1
@export var speed: float = 30.0

var gravity: float = 800.0
var facing: FACING = default_facing
var dying: bool = false
var player_ref: Player

func _ready():
	player_ref = Player.Instance

func _process(delta):
	pass

func _physics_process(delta):
	fallen_off()

func die():
	if dying:
		return
	
	dying = true
	SignalManager.on_enemy_hit.emit(points, global_position)
	set_physics_process(false)
	hide()
	queue_free()

func fallen_off():
	if global_position.y > OFF_SCREEN_KILL_ME:
		queue_free()

func on_screen_entered():
	pass

func on_screen_exited():
	pass

func on_hitbox_area_entered(area: Area2D):
	print("Enemy hit: ", area.name)
