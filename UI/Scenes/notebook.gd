extends Node2D

@onready var tutorial_1: RichTextLabel = %Tutorial1
@onready var tutorial_2: RichTextLabel = %Tutorial2
@onready var tutorial_3: RichTextLabel = %Tutorial3
@onready var tutorial_4: RichTextLabel = %Tutorial4
@onready var tutorial_1_container: VBoxContainer = %Tutorial1Container
@onready var tutorial_2_container: VBoxContainer = %Tutorial2Container
@onready var tutorial_3_container: VBoxContainer = %Tutorial3Container
@onready var tutorial_4_container: VBoxContainer = %Tutorial4Container

@onready var bio_1: RichTextLabel = %bio1
@onready var bio_2: RichTextLabel = %bio2
@onready var bio_3: RichTextLabel = %bio3
@onready var bio_4: RichTextLabel = %bio4
@onready var bio_5: RichTextLabel = %bio5

@onready var exit_button: TextureButton = %ExitButton

@onready var button_r: TextureButton = %ButtonR
@onready var button_l: TextureButton = %ButtonL
@onready var page_2: Control = %Page2
@onready var page_1: Control = %Page1
@onready var page_flip_sound_effect: AudioStreamWAV = load("res://Audio/sound-effects/page-flip-2.wav")
@onready var notebook_json_path: String = "res://UI/JSON/notebook_text.json"

const BOX_BREATHING = preload("res://Anxiety Effects/Box Breathing/box_breathing.tscn")
const EYE_CONTACT = preload("res://Anxiety Effects/Eye Contact/eye_contact.tscn")
const SELF_TALK = preload("res://Anxiety Effects/Self Talk/self_talk_minigame.tscn")

@export var showAll = false

var game_tut

signal exit_pressed

var pg = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bio_2.visible = false
	bio_3.visible = false
	bio_4.visible = false
	bio_5.visible = false
	tutorial_1_container.visible = false
	tutorial_2_container.visible = false
	tutorial_3_container.visible = false
	tutorial_4_container.visible = false
	update_page()
	load_tutorials()

func load_tutorials() -> void:
	if FileAccess.file_exists(notebook_json_path):
		var file = FileAccess.open(notebook_json_path, FileAccess.READ)
		var notebook_json = JSON.new()
		notebook_json = JSON.parse_string(file.get_as_text())
		bio_1.text = notebook_json["bio1_text"]
		bio_2.text = notebook_json["bio2_text"]
		bio_3.text = notebook_json["bio3_text"]
		bio_4.text = notebook_json["bio4_text"]
		tutorial_1.text = notebook_json["tut1_text"]
		tutorial_2.text = notebook_json["tut2_text"]
		tutorial_3.text = notebook_json["tut3_text"]
		tutorial_4.text = notebook_json["tut4_text"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func update_page():
	if (showAll == false):
		if (Player.save_file.get_value("player", "chapter") != null):
			bio_2.visible = Player.save_file.get_value("player", "chapter") > 3
			bio_3.visible = Player.save_file.get_value("player", "chapter") > 5
			bio_4.visible = Player.save_file.get_value("player", "chapter") > 7
			bio_5.visible = Player.save_file.get_value("player", "chapter") > 9
			tutorial_1_container.visible = Player.save_file.get_value("player", "has_done_box_breathing") != null
			tutorial_2_container.visible = Player.save_file.get_value("player", "has_done_self_talk") != null
			tutorial_3_container.visible = Player.save_file.get_value("player", "has_done_eye_contact") != null
	else:
		bio_2.visible = true
		bio_3.visible = true
		bio_4.visible = true
		bio_5.visible = true
		tutorial_1_container.visible = true
		tutorial_2_container.visible = true
		tutorial_3_container.visible = true
		
	match pg:
		1:
			page_1.visible = true
			page_2.visible = false
			button_l.modulate.a = 0
			button_l.disabled = true
			button_r.modulate.a = 1
			button_r.disabled = false
		2:
			page_1.visible = false
			page_2.visible = true
			button_l.modulate.a = 1
			button_l.disabled = false
			button_r.modulate.a = 0
			button_r.disabled = true

func _on_button_r_pressed():
	pg += 1
	update_page()
	GlobalAudio.play_sound_id(page_flip_sound_effect, "page_sound")

func _on_button_l_pressed():
	pg -= 1
	update_page()
	GlobalAudio.play_sound_id(page_flip_sound_effect, "page_sound")


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()


func _on_exit_button_mouse_entered() -> void:
	exit_button.modulate.v = .8


func _on_exit_button_mouse_exited() -> void:
	exit_button.modulate.v = 1



func _on_box_breathing_pressed() -> void:
	game_tut = BOX_BREATHING.instantiate();
	game_tut.show_tutorial = true
	game_tut.game_background = true
	add_child(game_tut)


func _on_eye_contact_pressed() -> void:
	game_tut = EYE_CONTACT.instantiate()
	game_tut.show_tutorial = true
	game_tut.game_background = true
	add_child(game_tut)


func _on_self_talk_pressed() -> void:
	game_tut = SELF_TALK.instantiate()
	game_tut.show_tutorial = true
	game_tut.game_background = true
	add_child(game_tut)
