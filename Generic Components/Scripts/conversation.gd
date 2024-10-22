class_name Conversation
extends Node2D

@onready var wants_to_talk: bool = true
@onready var character: Node2D = $Character
@onready var click_region: Area2D = $Character/ClickRegion
@onready var collision_shape_2d: CollisionShape2D = $Character/ClickRegion/CollisionShape2D
@onready var background: CanvasLayer = $Background

@onready var screen_width = get_viewport_rect().size.x
@onready var screen_height = get_viewport_rect().size.y
@onready var position_within_area: Vector2 = character.global_position
@onready var clicked = false

func _ready():
	if !wants_to_talk:
		collision_shape_2d.disabled = true
	background.visible = false

func on_click(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			if !clicked:
				character.global_position = Vector2(screen_width / 2, screen_height / 2)
				clicked = true
				background.visible = true
				
			else:
				character.global_position = position_within_area
				clicked = false
				background.visible = false
				
