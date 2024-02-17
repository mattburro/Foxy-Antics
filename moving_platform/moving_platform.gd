extends AnimatableBody2D

@export var speed: float = 50.0

var _tween: Tween
var _time_to_move: float = 0.0

@onready var point_1 = $Point1
@onready var point_2 = $Point2

func _ready():
	global_position = point_1.global_position
	set_time_to_move()
	set_moving()

func _exit_tree():
	_tween.kill()

func set_time_to_move():
	var delta = point_1.global_position.distance_to(point_2.global_position)
	_time_to_move = delta / speed

func set_moving():
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "global_position", point_2.global_position, _time_to_move)
	_tween.tween_property(self, "global_position", point_1.global_position, _time_to_move)
	_tween.set_loops()
