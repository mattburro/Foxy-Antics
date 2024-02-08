extends Node2D

@onready var player_camera = $PlayerCamera
@onready var player = $Player

func _physics_process(delta):
	player_camera.global_position = player.global_position
