extends Control

var _hearts: Array

@onready var end_screen = %EndScreen
@onready var level_complete = %LevelComplete
@onready var game_over = %GameOver
@onready var hearts_container = $MarginContainer/HBoxContainer/HeartsContainer
@onready var score_label = %ScoreLabel

func _ready():
	SignalManager.on_score_updated.connect(on_score_updated)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_player_hit.connect(on_player_hit)
	
	_hearts = hearts_container.get_children()

func _process(delta):
	if level_complete.visible:
		if Input.is_action_just_pressed("jump"):
			GameManager.load_next_level_scene()
	elif game_over.visible:
		if Input.is_action_just_pressed("jump"):
			GameManager.load_main_scene()

func show_hud():
	Engine.time_scale = 0
	end_screen.show()

func on_score_updated(score: int):
	score_label.text = str(score).lpad(4, "0")

func on_level_complete():
	show_hud()
	level_complete.show()
	game_over.hide()

func on_game_over():
	show_hud()
	game_over.show()
	level_complete.hide()

func on_player_hit(lives: int):
	for i in range(_hearts.size()):
		_hearts[i].visible = lives > i
