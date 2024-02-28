extends Node

const HIGH_SCORE_FILE: String = "user://scores.dat"
const HIGH_SCORE_KEY: String = "highscore"

var _score: int = 0
var _high_score: int = 0

func _ready():
	load_high_score()
	SignalManager.on_boss_killed.connect(on_boss_killed)
	SignalManager.on_enemy_hit.connect(on_enemy_hit)
	SignalManager.on_pickup_hit.connect(on_pickup_hit)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_game_over.connect(on_game_over)

func add_points_to_score(points: int):
	_score += points
	SignalManager.on_score_updated.emit(_score)
	
	if _score > _high_score:
		_high_score = _score

func get_score() -> int:
	return _score

func get_high_score() -> int:
	return _high_score

func reset_score():
	_score = 0

func save_high_score():
	var file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.WRITE)
	var data = {
		HIGH_SCORE_KEY: _high_score
	}
	file.store_string(JSON.stringify(data))

func load_high_score():
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		return
	
	var file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	if HIGH_SCORE_KEY in data:
		_high_score = data[HIGH_SCORE_KEY]

func on_boss_killed(points: int):
	add_points_to_score(points)

func on_enemy_hit(points: int, position: Vector2):
	add_points_to_score(points)

func on_pickup_hit(points: int):
	add_points_to_score(points)

func on_level_complete():
	save_high_score()

func on_game_over():
	save_high_score()
