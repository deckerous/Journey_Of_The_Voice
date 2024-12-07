extends Node2D

const SAVE_PATH = "user://save.cfg"
const TEST_SAVE_PATH = "res://Globals/save.cfg"

var save_path = TEST_SAVE_PATH

@onready var start_button: Button = $"CanvasLayer/VBoxContainer/VBoxContainer/CenterContainer - Start/StartButton"
@onready var continue_button: Button = $"CanvasLayer/VBoxContainer/VBoxContainer/CenterContainer - Load/ContinueButton"

@onready var confirm_popup: ColorRect = $CanvasLayer/ConfirmPopup
@onready var exit_button: Button = $CanvasLayer/ConfirmPopup/ExitButton
@onready var confirm_button: Button = $CanvasLayer/ConfirmPopup/ConfirmButton

@onready var music: AudioStreamWAV = load("res://Audio/songs/beep/beep-theme.wav")

@onready var chapters = {
	1: load("res://Chapters/Chapter 1/chapter_1.tscn"),
	2: load("res://Chapters/Chapter 2/chapter_2.tscn"),
	3: load("res://Chapters/Chapter 3/chapter_3.tscn"),
	4: load("res://Chapters/Chapter 4/chapter_4.tscn"),
	5: load("res://Chapters/Chapter 5/chapter_5.tscn"),
	6: load("res://Chapters/Chapter 6/chapter_6.tscn"),
	7: load("res://Chapters/Chapter 7/chapter_7.tscn"),
	8: load("res://Chapters/Chapter 8/chapter_8.tscn"),
	9: load("res://Chapters/Chapter 9/chapter_9.tscn"),
	10: load("res://Chapters/Chapter 10/chapter_10.tscn")
}

func _ready():
	confirm_popup.visible = false
	exit_button.pressed.connect(func(): confirm_popup.visible = false)
	confirm_button.pressed.connect(overwrite_confirmed)
	check_for_save()
	
	var stream = GlobalAudio.play_sound_id(music, "beep-theme", GlobalAudio.Bus.MUSIC)
	stream.volume_db = -15

func check_for_save():
	Player.load_save(save_path)
	
	# If there exists a save file, retrieve the chapter for the load button
	# to change the scene to when pressed and connect the new game button
	# to check if the user wants to overwrite their save.
	if Player.save_file.has_section("player"):
		start_button.pressed.connect(confirm_before_overwrite)
		continue_button.chapter_scene = chapters.get(Player.save_file.get_value("player", "chapter"))
		continue_button.make_connection_to_chapter()
	else:
		start_button.chapter_scene = chapters.get(1)
		start_button.make_connection_to_chapter()
		start_button.pressed.connect(create_save)
		continue_button.disabled = true

func confirm_before_overwrite():
	confirm_popup.visible = true

# Creates a new save file as config stored in appropriate directory.
func create_save():
	var config = ConfigFile.new()
	# Store chapter the player is starting on in "chapter".
	config.set_value("player", "chapter", 1)
	config.save(save_path)

func overwrite_confirmed():
	# Error handle a save file not existing, delete save file,
	# make fresh save file and save it, then go to chapter 1.
	var dir = DirAccess.open("res://")
	if dir.file_exists(save_path):
		dir.remove(save_path)
		create_save()
		GlobalAudio.stop_stream_from_id("beep-theme")
		get_tree().change_scene_to_packed(chapters.get(1))
	else:
		print("ERROR: Save file doesn't exist when trying to overwrite with New Game")
