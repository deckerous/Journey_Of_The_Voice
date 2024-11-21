extends Node

@onready var save_file = ConfigFile.new()

# When player exits the game or goes to the main menu and retrieves a save file
func load_save(save_file_path: String):
	save_file.load(save_file_path)
	
	# var saved_name = save_file.get_value("player", "name")
	# if saved_name == null: 
	# 	# Error handling
	# 	return 
