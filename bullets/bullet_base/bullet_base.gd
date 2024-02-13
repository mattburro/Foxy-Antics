extends Area2D

var _direction: Vector2 = Vector2.RIGHT
var _life_span: float = 20.0
var _life_time: float = 0.0

func _process(delta):
	check_life_time(delta)
	position += _direction * delta

func setup(spawn_position: Vector2, direction: Vector2, speed: float, life_span: float):
	global_position = spawn_position
	_direction = direction.normalized() * speed
	_life_span = life_span

func check_life_time(delta: float):
	_life_time += delta
	if _life_time > _life_span:
		queue_free()

func on_area_entered(_area: Area2D):
	queue_free()
