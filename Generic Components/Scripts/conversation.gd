class_name Conversation
extends Node2D

const SAVE_PATH = "user://game_stats.cfg"
const TEST_SAVE_PATH = "res://game_stats.cfg"
var save_path = TEST_SAVE_PATH

# .json file that the dialogue for the conversation will be read from
@export_file("*json") var dialogue_file: String
# Determines whether
@export var wants_to_talk: bool = true
# Controls if the starting character is alone when staring the convo,
# when turned false the other character in the convo appears
@export var starting_character_alone: bool = true
# Determines whether the starting character is on the right or left side of the screen
@export var starting_convo_character_right: bool = true

# Reference to parent node for handling character positioning and animation
@onready var conversation_characters: Node2D = $ConversationCharacters
@onready var character_collision_shape_2d: CollisionShape2D = $ConversationCharacters/StartingCharacter/CharacterClickArea/CharacterCollisionShape2D

# Dialogue UI node references
@onready var conversation_ui: CanvasLayer = $ConversationUI

@onready var dialogue_click_area: Area2D = $DialogueClickArea
@onready var dialogue_collision_shape_2d: CollisionShape2D = $DialogueClickArea/DialogueCollisionShape2D

@onready var ended_dialogue = false
@onready var dialogue_index = 1

@onready var dialogue_choice_button = preload("res://UI/Scenes/dialogue_choice_button.tscn")

# Holds dialogue text and other attributes accessed via keys
var dialogue_dictionary
# controls dialogue appearing character by character
var start_displaying = false

func _ready():
	# Connect signal for handling dialogue with click
	dialogue_click_area.input_event.connect(on_dialogue_click)
	
	# Show dialogue_ui when starting conversation
	conversation_characters.started_conversation.connect(conversation_ui.show)
	conversation_characters.started_conversation.connect(load_dialogue)
	
	conversation_ui.disable_dialogue_input.connect(disable_dialogue_click_collision)
	conversation_ui.enable_dialogue_input.connect(enable_dialogue_click_collision)
	
	# When loaded in to the chapter disable collision for continuing dialogue 
	dialogue_collision_shape_2d.disabled = true

# For advancing dialogue when in a conversation
func on_dialogue_click(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			conversation_ui.handle_dialogue()

# Initialize dialogue dictionary with provided .json file
func load_dialogue():
	if FileAccess.file_exists(dialogue_file):
		var file = FileAccess.open(dialogue_file, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		dialogue_dictionary = test_json_conv.get_data()
		conversation_ui.start_dialogue()
		dialogue_collision_shape_2d.disabled = false

func end_dialogue():
	ended_dialogue = true
	disable_dialogue_click_collision()

func toggle_dialogue_click_collision():
	dialogue_collision_shape_2d.disabled = !dialogue_collision_shape_2d.disabled

func enable_dialogue_click_collision():
	dialogue_collision_shape_2d.disabled = false

func disable_dialogue_click_collision():
	dialogue_collision_shape_2d.disabled = true
