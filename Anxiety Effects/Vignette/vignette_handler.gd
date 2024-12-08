extends Node2D

@onready var node = $Vignette
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Vignette/CanvasLayer/Sprite2D
@onready var canvas_layer = $Vignette/CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# apply_scale(Vector2(1.25, 1.25))
	global_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	canvas_layer.offset = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
