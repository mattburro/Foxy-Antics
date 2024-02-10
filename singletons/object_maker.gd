extends Node

enum BULLET_KEY { PLAYER, ENEMY }

const BULLETS = {
	BULLET_KEY.PLAYER: preload("res://bullets/bullet_player/bullet_player.tscn"),
	BULLET_KEY.ENEMY: preload("res://bullets/bullet_enemy/bullet_enemy.tscn")
}

func add_child_deferred(child):
	get_tree().root.add_child(child)

func call_add_child_deferred(child):
	call_deferred("add_child_deferred", child)

func create_bullet(key: BULLET_KEY, position: Vector2, direction: Vector2, speed: float, life_span: float):
	var new_bullet = BULLETS[key].instantiate()
	new_bullet.setup(position, direction, speed, life_span)
	call_add_child_deferred(new_bullet)
