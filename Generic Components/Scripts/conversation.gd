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

# For when a conversation immediately follows a monologue without player input
@export var start_conversation_after_monologue: bool = false
# For when you want to this conversation to play on load
@export var start_conversation_on_load: bool = false

@export var end_anxiety_effect: bool

# Controls whether another conversation should follow this one after it is done.
@export var has_following_conversation: bool = false
@export var following_conversation: PackedScene

@export var following_conversation_path: String

# Controls whether a failure conversation should follow this one after it is done.
# Something like the Guide saying "Wow you really flubbed that!"
@export var has_failure_conversation: bool = false
@export var failure_conversation: PackedScene

@export var has_following_monologue: bool = false
@export var following_monologue: PackedScene

@export var has_following_minigame: bool = false
@export var following_minigame: PackedScene

@export var end_of_chapter: bool

# Reference to parent node for handling character positioning and animation
@onready var conversation_characters: Node2D = $ConversationCharacters
@onready var character_collision_shape_2d: CollisionShape2D = $ConversationCharacters/StartingCharacter/CharacterClickArea/CharacterCollisionShape2D

# Dialogue UI node references
@onready var conversation_ui: CanvasLayer = $ConversationUI

@onready var dialogue_click_area: Area2D = $DialogueClickArea
@onready var dialogue_collision_shape_2d: CollisionShape2D = $DialogueClickArea/DialogueCollisionShape2D

# Reference to animation node that controls fading in and fading out animations
@onready var conversation_animation_player = $ConversationAnimationPlayer

@onready var ended_dialogue = false
@onready var dialogue_index = 1

@onready var dialogue_choice_button = preload("res://UI/Scenes/dialogue_choice_button.tscn")

# Holds dialogue text and other attributes accessed via keys
var dialogue_dictionary
# controls dialogue appearing character by character
var start_displaying = false

signal started_conversation
signal finished_conversation
signal failed_conversation

signal start_anxiety_effect(anxiety_effect: String)

signal faded_out_characters

func _ready():
	# Connect signal from conversation_characters in order to unhide conversations in area.
	# Uses lambda function to avoid new function decleration for "forwarding" signal updwards.
	conversation_characters.started_conversation.connect(func(): self.started_conversation.emit())

	# Connect signal for handling dialogue with click
	dialogue_click_area.input_event.connect(on_dialogue_click)

	# Show dialogue_ui when starting conversation
	conversation_characters.started_conversation.connect(conversation_ui.show)
	# If this is a conversation the player clicked on, wait to load and start dialogue
	# until characters have been moved to the correct place
	if wants_to_talk:
		self.faded_out_characters.connect(load_dialogue)

	conversation_ui.disable_dialogue_input.connect(disable_dialogue_click_collision)
	conversation_ui.enable_dialogue_input.connect(enable_dialogue_click_collision)

	# When loaded in to the chapter disable collision for continuing dialogue
	dialogue_collision_shape_2d.disabled = true

	# Connect up the signal that passes on which anxiety effect to play
	conversation_ui.start_anxiety_effect.connect(instance_anxiety_effect)

	conversation_ui.fade_out_character.connect(fade_out_character)
	conversation_characters.started_conversation.connect(move_charcters)

	if start_conversation_after_monologue or start_conversation_on_load:
		conversation_ui.show()
		conversation_animation_player.play("fade_in")
		await conversation_animation_player.animation_finished
		load_dialogue()
	else:
		conversation_animation_player.play("fade_in")
		await conversation_animation_player.animation_finished

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
	#if has_following_monologue or has_following_conversation:
	self.finished_conversation.emit()
	conversation_animation_player.play("fade_out")
	await conversation_animation_player.animation_finished
	self.queue_free()

# Simply emits a signal letting the scene know that we failed this conversation
# Intended to be used for when you want to choose between two different convo
# scenes following this one depending on whether you failed or not
# I frikking hate that I'm copy and pasting most of the above function but the
# alternative is making a new function with a better name and potentially messing
# up everything that uses end_dialogue
func fail_dialogue():
	self.failed_conversation.emit()
	ended_dialogue = true
	disable_dialogue_click_collision()
	#if has_following_monologue or has_following_conversation:
	conversation_animation_player.play("fade_out")
	await conversation_animation_player.animation_finished
	self.queue_free()


func instance_anxiety_effect():
	start_anxiety_effect.emit()

func fade_out_convo():
	conversation_animation_player.play("fade_out")

func fade_in_convo():
	conversation_animation_player.play("fade_in")

func fade_out_character():
	conversation_animation_player.play("fade_out_other_character")

func fade_out_characters():
	conversation_animation_player.play("fade_out_characters")

func fade_in_characters():
	conversation_animation_player.play("fade_in_characters")

func move_charcters():
	fade_out_characters()
	await conversation_animation_player.animation_finished
	self.faded_out_characters.emit()
	fade_in_characters()

func toggle_dialogue_click_collision():
	dialogue_collision_shape_2d.disabled = !dialogue_collision_shape_2d.disabled

func enable_dialogue_click_collision():
	dialogue_collision_shape_2d.disabled = false

func disable_dialogue_click_collision():
	dialogue_collision_shape_2d.disabled = true
