extends Node2D

const TRIGGER_CONDITION: String = "parameters/conditions/on_trigger"
const HIT_CONDITION: String = "parameters/conditions/on_hit"

@export var lives: int = 2
@export var points: int = 5

var _invincible: bool = false

@onready var animation_tree = $AnimationTree
@onready var visuals = $Visuals

func tween_hit():
	var tween = get_tree().create_tween()
	tween.tween_property(visuals, "position", Vector2.ZERO, 1.0)

func reduce_lives():
	lives -= 1
	if lives <= 0:
		SignalManager.on_boss_killed.emit(points)
		set_process(false)
		queue_free()

func set_invincible(value: bool):
	_invincible = value
	animation_tree[HIT_CONDITION] = value

func take_damage():
	if _invincible:
		return
	
	set_invincible(true)
	tween_hit()
	reduce_lives()

func on_activation_trigger_area_entered(area):
	if not animation_tree[TRIGGER_CONDITION]:
		animation_tree[TRIGGER_CONDITION] = true

func on_hitbox_area_entered(area):
	take_damage()
