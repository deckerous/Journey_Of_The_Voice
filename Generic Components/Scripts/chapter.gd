class_name Chapter
extends Node

const SAVE_PATH = "user://save.cfg"
const TEST_SAVE_PATH = "res://Globals/save.cfg"

var save_path = TEST_SAVE_PATH

@export var chapter_number: int
@export var next_chapter: PackedScene
@export var area: Area

@onready var continue_button: Button = $CanvasLayer/ContinueButton

# Alerts other nodes when we're changing chapters
signal clicked

func _ready() -> void:
	if area != null:
		area.area_complete.connect(unhide_continue_button)
		continue_button.pressed.connect(go_to_next_chapter)

func unhide_continue_button():
	continue_button.visible = true

func go_to_next_chapter():
	# Alert other nodes that we're switching chapters
	clicked.emit()
	Player.update_chapter(chapter_number + 1)
	Player.write_save(save_path)
	get_tree().change_scene_to_packed(next_chapter)
