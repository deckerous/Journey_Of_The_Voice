class_name Chapter
extends Node

@export var next_chapter: PackedScene
@export var area: Area

@onready var continue_button: Button = $CanvasLayer/ContinueButton

func _ready() -> void:
	if area != null:
		area.area_complete.connect(unhide_continue_button)
		continue_button.pressed.connect(go_to_next_chapter)

func unhide_continue_button():
	continue_button.visible = true

func go_to_next_chapter():
	get_tree().change_scene_to_packed(next_chapter)
