extends Node

enum BULLET_KEY { PLAYER, ENEMY }
enum SCENE_KEY { EXPLOSION, PICKUP }

const BULLETS = {
	BULLET_KEY.PLAYER: preload("res://bullets/bullet_player/bullet_player.tscn"),
	BULLET_KEY.ENEMY: preload("res://bullets/bullet_enemy/bullet_enemy.tscn")
}
const SCENES = {
	SCENE_KEY.EXPLOSION:  preload("res://explosion/explosion.tscn"),
	SCENE_KEY.PICKUP: preload("res://fruit_pickup/fruit_pickup.tscn")
}

func add_child_deferred(child):
	get_tree().root.add_child(child)

func call_add_child_deferred(child):
	call_deferred("add_child_deferred", child)

func create_bullet(key: BULLET_KEY, position: Vector2, direction: Vector2, speed: float, life_span: float):
	var new_bullet = BULLETS[key].instantiate()
	new_bullet.setup(position, direction, speed, life_span)
	call_add_child_deferred(new_bullet)

func create_scene(key: SCENE_KEY, position: Vector2):
	var new_scene = SCENES[key].instantiate()
	new_scene.global_position = position
	call_add_child_deferred(new_scene)
