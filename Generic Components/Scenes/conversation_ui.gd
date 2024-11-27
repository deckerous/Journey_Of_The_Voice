extends CanvasLayer

@onready var conversation: Conversation = get_parent()

# Child UI node references
@onready var character_dialogue: VBoxContainer = $Dialogue/Control/CharacterDialogue
@onready var name_label: Label = $Dialogue/Control/CharacterDialogue/NameLabel
@onready var dialogue_label: RichTextLabel = $Dialogue/Control/CharacterDialogue/HBoxContainer/DialogueLabel
@onready var dialogue_choices: VBoxContainer = $Dialogue/Control/DialogueChoices

# Button template for instantiating branching dialogue button options
@onready var dialogue_choice_button = preload("res://UI/Scenes/dialogue_choice_button.tscn")

@onready var dialogue_index = 1

# controls dialogue appearing character by character
@onready var start_displaying = false

# Name of the character that is currently speaking. You by default
@onready var char_talking: String = "You"

# Pitch of the voice for whoever's talking
var speech_pitch: float

# For parent to enable/disable dialogue input checks
signal disable_dialogue_input
signal enable_dialogue_input

signal anxiety_effect

signal fade_out_character

func _ready():
	# When loaded in to the chapter, hide the conversation_ui and collision for continuing dialogue 
	self.visible = false
	dialogue_choices.visible = false
	speech_pitch = 1.0

func _process(delta: float) -> void:
	if dialogue_label.visible_ratio == 1.0:
		start_displaying = false
		speech_pitch = 1.0
	if start_displaying:
		dialogue_label.visible_characters += 1
		# Load the Wav file based on who is currently talking
		var speech_wav: AudioStreamWAV = load("res://Audio/voices/"+char_talking+".wav")
		speech_pitch += randf_range(-0.1, 0.1)
		print(char_talking);
		GlobalAudio.play_sound_id(speech_wav, "speech_audio", GlobalAudio.Bus.SFX, speech_pitch)

func start_dialogue():
	name_label.text = conversation.dialogue_dictionary["dialogue"][0]["character"]
	char_talking = conversation.dialogue_dictionary["dialogue"][0]["character"]
	dialogue_label.text = conversation.dialogue_dictionary["dialogue"][0]["text"]
	display_characters()

func handle_dialogue():
	character_dialogue.visible = true
	dialogue_choices.visible = false
	enable_dialogue_input.emit()
	
	if dialogue_label.visible_ratio != 1.0:
		# When the dialogue is still appearing and another 
		# click comes in, skip to being fully visible
		
		dialogue_label.visible_ratio = 1.0
	
	elif conversation.dialogue_dictionary["dialogue"][dialogue_index].has("function"):
		# Run any functions that the text has
		
		if conversation.dialogue_dictionary["dialogue"][dialogue_index]["function"] == "end_dialogue":
			conversation.end_dialogue()
		elif conversation.dialogue_dictionary["dialogue"][dialogue_index]["function"] == "branch_dialogue":
			# Provide error message and end dialogue if there aren't options labeled for the dialogue branch
			
			if !conversation.dialogue_dictionary["dialogue"][dialogue_index].has("options"):
				dialogue_label.text = "ERROR: No options? Make sure the .json file has an options string array field that corresponds to a dialogue id."
				conversation.end_dialogue()
			
			# Continue to dialogue branching
			branch_dialogue(conversation.dialogue_dictionary["dialogue"][dialogue_index]["options"])
		elif conversation.dialogue_dictionary["dialogue"][dialogue_index]["function"] == "anxiety_effect":
			dialogue_label.text = conversation.dialogue_dictionary["dialogue"][dialogue_index]["text"]
			self.anxiety_effect.emit()
			display_characters()
			dialogue_index += 1
		elif conversation.dialogue_dictionary["dialogue"][dialogue_index]["function"] == "other_character_leaves":
			dialogue_label.text = conversation.dialogue_dictionary["dialogue"][dialogue_index]["text"]
			self.fade_out_character.emit()
			display_characters()
			dialogue_index += 1
	else:
		dialogue_label.text = conversation.dialogue_dictionary["dialogue"][dialogue_index]["text"]
		
		# change displayed name to character's name
		if conversation.dialogue_dictionary["dialogue"][dialogue_index].has("character"):
			name_label.text = conversation.dialogue_dictionary["dialogue"][dialogue_index]["character"]
			# Grab the name of the character whose talking. Used for the speech dialogue
			char_talking = conversation.dialogue_dictionary["dialogue"][dialogue_index]["character"]
		display_characters()
		dialogue_index += 1

func branch_dialogue(options: Array):
	# instantiate the number of buttons to the number of options the text option has, 
	# and have them return an id based on the text
	character_dialogue.visible = false
	dialogue_choices.visible = true
	disable_dialogue_input.emit()
	
	for option in options:
		var choice = dialogue_choice_button.instantiate()
		choice.text = option
		choice.pressed.connect(change_dialogue_index.bind(option))
		dialogue_choices.add_child(choice)

func change_dialogue_index(option: String):
	for i in range(len(conversation.dialogue_dictionary["dialogue"])):
		if conversation.dialogue_dictionary["dialogue"][i].has("id") and conversation.dialogue_dictionary["dialogue"][i]["id"] == option:
			dialogue_index = i
			for child in dialogue_choices.get_children():
				child.queue_free()
			handle_dialogue()
			enable_dialogue_input.emit()
			return

# Begins dialogue scrolling when dialogue advances
func display_characters():
	dialogue_label.visible_characters = 0
	start_displaying = true
