extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const CREDITS_THEME = preload("res://Audio/songs/credits/credits-theme.wav")
@onready var continue_button = $ButtonContainer/Control/ContinueButton
@onready var main_menu = load("res://UI/Scenes/main_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.play_sound_id(CREDITS_THEME, "music", GlobalAudio.Bus.MUSIC).volume_db = -7
	
	continue_button.pressed.connect(go_to_main_menu)

func go_to_main_menu():
	get_tree().change_scene_to_packed(main_menu)
