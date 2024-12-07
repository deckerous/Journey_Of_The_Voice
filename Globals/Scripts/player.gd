extends Node

const SAVE_PATH = "user://save.cfg"
const TEST_SAVE_PATH = "res://Globals/save.cfg"

@onready var save_path = TEST_SAVE_PATH

@onready var save_file: ConfigFile

func _ready():
	load_save()

# When player exits the game or goes to the main menu and retrieves a save file
func load_save() -> void:
	var config = ConfigFile.new()
	config.load(save_path)
	save_file = config
	#save_file.load(save_path)

func write_save() -> void:
	save_file.save(save_path)

func update_chapter(chapter_number: int) -> void:
	save_file.set_value("player", "chapter", chapter_number)

# Adds a check to the save file that will be referenced throughout the game,
# resave save file after adding check
func add_check(check: String) -> void:
	save_file.set_value("player", check, true)
	save_file.save(save_path)
