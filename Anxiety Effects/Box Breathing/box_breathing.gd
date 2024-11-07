extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var centerX = get_viewport_rect().size.x / 2
	var centerY = get_viewport_rect().size.y / 2
	
	position = Vector2(centerX, centerY)
