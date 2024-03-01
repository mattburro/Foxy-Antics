extends Node2D

@onready var player_camera = $PlayerCamera
@onready var player = $Player

func _ready():
	Engine.time_scale = 1

func _process(_delta):
	player_camera.global_position = player.global_position
