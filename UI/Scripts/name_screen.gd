extends Control

@onready var name_line_edit: LineEdit = $VBoxContainer/NameLineEdit
@onready var confirm_button: Button = $VBoxContainer/ConfirmButton
@onready var load_name_label: Label = $LoadNameLabel

const SAVE_PATH = "user://game_stats.cfg"
const TEST_SAVE_PATH = "res://game_stats.cfg"
var save_path = TEST_SAVE_PATH

func _ready() -> void:
	# When confirm_button is pressed, save the name in the name_line_edit
	confirm_button.pressed.connect(confirm_pressed)

func confirm_pressed() -> void:
	if !valid_name(name_line_edit.text):
		# Name not valid, do not confirm and save
		return
	else:
		# Confirm name and create save file
		name_line_edit.editable = false
		create_save(name_line_edit.text)
		load_save()

func valid_name(save_name: String) -> bool:
	if save_name.length() < 1:
		# Clear input text and give error message through placeholder text
		name_line_edit.text = ""
		name_line_edit.placeholder_text = "Must be >1 characters..."
		return false
	else: 
		return true

func create_save(save_name: String) -> void:
	var config = ConfigFile.new()
	config.set_value("player", "name", save_name)
	config.save(save_path)

func load_save():
	var save_file = ConfigFile.new()
	save_file.load(save_path)
	var saved_name = save_file.get_value("player", "name")
	if saved_name == null: 
		# Error handling
		return 
	load_name_label.text = "Saved name: " + saved_name
