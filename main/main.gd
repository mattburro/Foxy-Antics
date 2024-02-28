extends CanvasLayer

@onready var high_score_label = %HighScoreLabel

func _ready():
	high_score_label.text = "High Score: %s" % str(ScoreManager.get_high_score()).lpad(4, "0")

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		GameManager.load_next_level_scene()
