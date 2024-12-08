extends Node

@onready var save_file: ConfigFile = ConfigFile.new()
@onready var save_file_path: String = ""

# When player exits the game or goes to the main menu and retrieves a save file
func load_save(save_file_path: String) -> void:
	save_file.load(save_file_path)
	self.save_file_path = save_file_path

func write_save(save_file_path: String):
	save_file.save(save_file_path)

func update_chapter(chapter_number: int) -> void:
	save_file.set_value("player", "chapter", chapter_number)

# Adds a check to the save file that will be referenced throughout the game,
# resave save file after adding check
func add_check(check: String) -> void:
	save_file.set_value("player", check, true)
	save_file.save(save_file_path)
