class_name Chapter
extends Node

const SAVE_PATH = "user://save.cfg"
const TEST_SAVE_PATH = "res://Globals/save.cfg"

var save_path = TEST_SAVE_PATH

@export var chapter_number: int
@export var next_chapter: PackedScene
@export var area: Area

@onready var continue_button: TextureButton = $CanvasLayer/ContinueButton

# Alerts other nodes when we're changing chapters
signal clicked

func _ready() -> void:
	continue_button.visible = false
	if area != null:
		area.area_complete.connect(unhide_continue_button)
		continue_button.pressed.connect(go_to_next_chapter)
	
	area.interactable_now_visible.connect(hide_continue_button)
	area.interactable_now_invisible.connect(unhide_continue_button)

func hide_continue_button():
	continue_button.visible = false

func unhide_continue_button():
	continue_button.visible = true

func go_to_next_chapter():
	# Alert other nodes that we're switching chapters
	clicked.emit()
	Player.update_chapter(chapter_number + 1)
	Player.write_save(save_path)
	ConversationArchive.clear_archive()
	get_tree().change_scene_to_packed(next_chapter)
