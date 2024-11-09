extends Node2D

# 
@onready var conversation: Conversation = get_parent()

# Starting character references
@onready var starting_character: Node2D = $StartingCharacter
@onready var starting_character_animation_player: AnimationPlayer = $StartingCharacter/StartingCharacterAnimationPlayer
@onready var character_click_area: Area2D = $StartingCharacter/CharacterClickArea
@onready var character_collision_shape_2d: CollisionShape2D = $StartingCharacter/CharacterClickArea/CharacterCollisionShape2D

# Other charcater references
@onready var other_character: Node2D = $OtherCharacter
@onready var other_character_animation_player: AnimationPlayer = $OtherCharacter/OtherCharacterAnimationPlayer

# Variables for character positioning within conversation 
@onready var screen_width = get_viewport_rect().size.x
@onready var screen_height = get_viewport_rect().size.y
@onready var middle_position = Vector2(screen_width / 2.0, screen_height / 2.0)
@onready var right_position = Vector2((screen_width / 2.25) + (screen_width / 4.0), screen_height / 2.0)
@onready var left_position = Vector2((screen_width / 2.25) - (screen_width / 4.0), screen_height / 2.0)
@onready var starting_character_position_within_area: Vector2 = starting_character.global_position

@onready var in_dialogue = false
@onready var clicked = false

signal started_conversation

func _ready() -> void:
	# Connect signal to the 
	character_click_area.input_event.connect(on_character_click)
	
	# Disable collision when character does not want to talk
	if !conversation.wants_to_talk:
		character_collision_shape_2d.disabled = true

# Handle starting the conversation and positioning characters 
# within the conversation on conversation start
func on_character_click(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if !in_dialogue:
			if event.is_action_pressed("click"):
				in_dialogue = true
				if !conversation.starting_character_alone:
					position_chatacters()
				else:
					# Place character in the middle if they are alone
					starting_character.global_position = middle_position
				clicked = true
				started_conversation.emit()

# Place characters in positions within conversation 
# according to export var starting_convo_character_right.
# Can be called when another character joins conversation half way through.
func position_chatacters():
	
	if conversation.starting_convo_character_right:
		starting_character.global_position = right_position
		other_character.global_position = left_position
	else:
		starting_character.global_position = left_position
		other_character.global_position = right_position
