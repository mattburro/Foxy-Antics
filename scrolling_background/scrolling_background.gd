extends ParallaxBackground

const BACKGROUND_IMAGE_PATHS = {
	1: [
		"res://assets/backgrounds/game_background_1/layers/sky.png",
		"res://assets/backgrounds/game_background_1/layers/clouds_1.png",
		"res://assets/backgrounds/game_background_1/layers/clouds_2.png",
		"res://assets/backgrounds/game_background_1/layers/clouds_3.png",
		"res://assets/backgrounds/game_background_1/layers/clouds_4.png",
		"res://assets/backgrounds/game_background_1/layers/rocks_1.png",
		"res://assets/backgrounds/game_background_1/layers/rocks_2.png"
	],
	2: [
		"res://assets/backgrounds/game_background_2/layers/sky.png",
		"res://assets/backgrounds/game_background_2/layers/birds.png",
		"res://assets/backgrounds/game_background_2/layers/clouds_1.png",
		"res://assets/backgrounds/game_background_2/layers/clouds_2.png",
		"res://assets/backgrounds/game_background_2/layers/clouds_3.png",
		"res://assets/backgrounds/game_background_2/layers/pines.png",
		"res://assets/backgrounds/game_background_2/layers/rocks_1.png",
		"res://assets/backgrounds/game_background_2/layers/rocks_2.png",
		"res://assets/backgrounds/game_background_2/layers/rocks_3.png"
	],
	3: [
		"res://assets/backgrounds/game_background_3/layers/sky.png",
		"res://assets/backgrounds/game_background_3/layers/clouds_1.png",
		"res://assets/backgrounds/game_background_3/layers/clouds_2.png",
		"res://assets/backgrounds/game_background_3/layers/ground_1.png",
		"res://assets/backgrounds/game_background_3/layers/ground_2.png",
		"res://assets/backgrounds/game_background_3/layers/ground_3.png",
		"res://assets/backgrounds/game_background_3/layers/plant.png",
		"res://assets/backgrounds/game_background_3/layers/rocks.png"
	],
	4: [
		"res://assets/backgrounds/game_background_4/layers/sky.png",
		"res://assets/backgrounds/game_background_4/layers/clouds_1.png",
		"res://assets/backgrounds/game_background_4/layers/clouds_2.png",
		"res://assets/backgrounds/game_background_4/layers/ground.png",
		"res://assets/backgrounds/game_background_4/layers/rocks.png"
	]
}

@export_range(1, 4) var level_number: int = 1
@export var mirror_x: float = 1440.0
@export var sprite_offset: Vector2 = Vector2(0, -540)
@export var sprite_scale: Vector2 = Vector2(0.75, 0.75)

func _ready():
	add_backgrounds()

func add_backgrounds():
	var increment = get_increment()
	var motion_scale_x = increment
	var background_paths = BACKGROUND_IMAGE_PATHS[level_number]
	
	for index in range(background_paths.size()):
		var background_path = background_paths[index]
		var background_image = load(background_path)
		var is_scrolling = background_path.contains("cloud")
		
		if index == 0:
			add_layer(is_scrolling, background_image, 0)
		else:
			add_layer(is_scrolling, background_image, motion_scale_x)
			motion_scale_x += increment

func add_layer(is_scrolling: bool, t: Texture2D, motion_scale_x: float):
	var new_layer
	if is_scrolling:
		new_layer = ScrollingParallaxLayer.new()
		new_layer.speed *= motion_scale_x
	else:
		new_layer = ParallaxLayer.new()
	
	new_layer.motion_mirroring = Vector2(mirror_x, 0)
	new_layer.motion_scale = Vector2(motion_scale_x, 1)
	var sprite = get_sprite(t)
	new_layer.add_child(sprite)
	add_child(new_layer)

func get_sprite(t: Texture2D) -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = t
	sprite.scale = sprite_scale
	sprite.offset = sprite_offset
	return sprite

func get_increment() -> float:
	return 1.0 / BACKGROUND_IMAGE_PATHS[level_number].size()
