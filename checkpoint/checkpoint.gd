extends Area2D

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"

@onready var animation_tree = $AnimationTree
@onready var sound = $Sound

func _ready():
	SignalManager.on_boss_killed.connect(on_boss_killed)

func on_boss_killed(_points: int):
	animation_tree[TRIGGER_CONDITION] = true
	monitoring = true

func on_area_entered(area: Area2D):
	SoundManager.play_sound(sound, SoundManager.SOUND_WIN)
	SignalManager.on_level_complete.emit()
