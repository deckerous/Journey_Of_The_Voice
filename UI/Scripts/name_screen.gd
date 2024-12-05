extends Control

const SAVE_PATH_1 = "user://"
const SAVE_PATH_2 = ".cfg"
const TEST_SAVE_PATH_1 = "res://Globals/"
const TEST_SAVE_PATH_2 = ".cfg"

var debug = true
var save_path = ""

const CHAPTER_1 = preload("res://Chapters/Chapter 1/chapter_1.tscn")

@onready var name_line_edit = $VBoxContainer2/VBoxContainer/NameLineEdit
@onready var confirm_button = $VBoxContainer2/VBoxContainer/ConfirmButton

func _ready() -> void:
	# When confirm_button is pressed, save the name in the name_line_edit
	confirm_button.pressed.connect(confirm_pressed)

# Handles error validation for when creating new save name
func confirm_pressed() -> void:
	var name = name_line_edit.text
	if !valid_name(name):
		# Name not valid, do not confirm and save
		return
	else:
		# Confirm name and create save file
		name_line_edit.editable = false
		create_save(name)
		# Set save file the player references to be this new save file
		Player.load_save(save_path)
		# Go to chapter 1
		get_tree().change_scene_to_packed(CHAPTER_1)

# Error handles the name the player inputs, returning true when valid
func valid_name(save_name: String) -> bool:
	if save_name.length() < 1 or save_name.length() > 30:
		# Clear input text and give error message through placeholder text
		name_line_edit.text = ""
		name_line_edit.placeholder_text = "Must between 1 and 30 characters..."
		return false
	else: 
		return true

# Creates a new save file as config stored in appropriate directory
# using the given name.
func create_save(save_name: String) -> void:
	var config = ConfigFile.new()
	# Store name for save file under "name" and
	# chapter the player is starting on in "chapter".
	config.set_value("player", "name", save_name)
	config.set_value("player", "chapter", 1)
	
	save_path = create_new_save_path(save_name)
	config.save(save_path)

# Forms save path name given the player input name out of const save path components
func create_new_save_path(name: String) -> String:
	var save_path = ""
	
	# Before final release debug will make save file local to the current project directory.
	# Change when ready to release so that save files are in the app data directory.
	if debug:
		save_path = TEST_SAVE_PATH_1 + name + TEST_SAVE_PATH_2
	else:
		save_path = SAVE_PATH_1 + name + SAVE_PATH_2
	return save_path
