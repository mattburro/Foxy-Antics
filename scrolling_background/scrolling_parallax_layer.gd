class_name ScrollingParallaxLayer extends ParallaxLayer

var speed: float = -20.0

func _process(delta):
	motion_offset.x += speed * delta
