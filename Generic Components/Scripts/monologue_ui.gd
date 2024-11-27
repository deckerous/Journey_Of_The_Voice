extends CanvasLayer

@onready var monologue: Monologue = get_parent()

# Child UI node references
@onready var dialogue_label: RichTextLabel = $Monologue/Control/MonologueTextContainer/DialogueLabel

@onready var dialogue_index = 0

# controls dialogue appearing character by character
@onready var start_displaying = false
@onready var speech_wav: AudioStreamWAV = load("res://Audio/voices/Monologue.wav")
var speech_pitch: float

# For parent to enable/disable dialogue input checks
signal disable_monologue_input
signal enable_monologue_input

func _process(delta: float) -> void:
	# Handle displaying characters one character at a time
	if dialogue_label.visible_ratio == 1.0:
		start_displaying = false
		speech_pitch = 1.0
	if start_displaying:
		dialogue_label.visible_characters += 1
		speech_pitch = 1.0
		speech_pitch += randf_range(-0.1, 0.1)
		GlobalAudio.play_sound_id(speech_wav, "speech_audio", GlobalAudio.Bus.SFX, speech_pitch)

# Starts up the json file reading from the first index
func start_monologue():
	dialogue_label.text = "[center]" + monologue.monologue_dictionary["monologue"][0]["text"] + "[/center]"
	display_characters()

# Updates the dialogue appearing on screen and effects when the player clicks the screen
func handle_monologue():
	if dialogue_label.visible_ratio != 1.0:
		# When the dialogue is still appearing and another 
		# click comes in, skip to being fully visible
		dialogue_label.visible_ratio = 1.0
	elif monologue.monologue_dictionary["monologue"][dialogue_index].has("function"):
		# Run any functions that the text has
		if monologue.monologue_dictionary["monologue"][dialogue_index]["function"] == "end_monologue":
			monologue.end_monologue()
		
		# Potentially add anxiety increasing function here for when player has self-doubting thoughts
		
	else:
		dialogue_label.text = "[center]" + monologue.monologue_dictionary["monologue"][dialogue_index]["text"] + "[/center]"
		display_characters()
		dialogue_index += 1

# Begins dialogue scrolling when dialogue advances
func display_characters():
	dialogue_label.visible_characters = 0
	start_displaying = true
