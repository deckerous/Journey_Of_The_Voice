class_name Conversation
extends Node2D

@export_file("*json") var dialogue_file: String
@export var wants_to_talk: bool = true

@onready var character: Node2D = $Character
@onready var character_click_area: Area2D = $Character/CharacterClickArea
@onready var character_collision_shape_2d: CollisionShape2D = $Character/CharacterClickArea/CharacterCollisionShape2D
@onready var background: CanvasLayer = $Background
@onready var name_label: Label = $Background/Dialogue/Control/VBoxContainer/NameLabel
@onready var dialogue_label: RichTextLabel = $Background/Dialogue/Control/VBoxContainer/HBoxContainer/DialogueLabel
@onready var dialogue_click_area: Area2D = $DialogueClickArea
@onready var dialogue_collision_shape_2d: CollisionShape2D = $DialogueClickArea/DialogueCollisionShape2D
@onready var leave_dialogue_button: TextureButton = $Background/LeaveDialogueButton

@onready var screen_width = get_viewport_rect().size.x
@onready var screen_height = get_viewport_rect().size.y
@onready var position_within_area: Vector2 = character.global_position
@onready var clicked = false
@onready var in_dialogue = false
@onready var ended_dialogue = false
@onready var dialogue_index = 1

# Holds dialogue text and other attributes accessed via keys
var dialogue_dictionary

var start_displaying = false

func _ready():
	# Connect the signals sent out on click input
	character_click_area.input_event.connect(on_character_click)
	dialogue_click_area.input_event.connect(on_dialogue_click)
	
	# Disable collision when character does not want to talk
	if !wants_to_talk:
		character_collision_shape_2d.disabled = true
	
	# When loaded in to the chapter, hide the background and collision for continuing dialogue 
	background.visible = false
	dialogue_collision_shape_2d.disabled = true

func _process(delta: float) -> void:
	if dialogue_label.visible_ratio == 1.0:
		start_displaying = false
	if start_displaying:
		dialogue_label.visible_characters += 1
		print(dialogue_label.visible_characters)

# For when outside of conversation and you want to intiate the conversation
# by clicking on the character
func on_character_click(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if !in_dialogue:
			if event.is_action_pressed("click"):
				in_dialogue = true
				if !clicked:
					character.global_position = Vector2(screen_width / 2, screen_height / 2)
					clicked = true
					background.visible = true
					load_dialogue()
					dialogue_collision_shape_2d.disabled = false
				else:
					character.global_position = position_within_area
					clicked = false
					background.visible = false

# For advancing dialogue when in a conversation
func on_dialogue_click(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			handle_dialogue()

# Initialize dialogue dictionary with provided .json file
func load_dialogue():
	if FileAccess.file_exists(dialogue_file):
		var file = FileAccess.open(dialogue_file, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		dialogue_dictionary = test_json_conv.get_data()
		name_label.text = dialogue_dictionary["dialogue"][0]["character"]
		dialogue_label.text = dialogue_dictionary["dialogue"][0]["text"]
		display_characters()

func handle_dialogue():
	if dialogue_dictionary["dialogue"][dialogue_index].has("function") and dialogue_dictionary["dialogue"][dialogue_index]["function"] == "end_dialogue":
		end_dialogue()
	else:
		dialogue_label.text = dialogue_dictionary["dialogue"][dialogue_index]["text"]
		display_characters()
		dialogue_index += 1

func end_dialogue():
	ended_dialogue = true
	dialogue_collision_shape_2d.disabled = true

func display_characters():
	dialogue_label.visible_characters = 0
	start_displaying = true
