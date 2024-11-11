extends CanvasLayer

@onready var monologue: Monologue = get_parent()

# Child UI node references
@onready var dialogue_label: RichTextLabel = $Monologue/Control/MonologueTextContainer/DialogueLabel

@onready var dialogue_index = 0

# controls dialogue appearing character by character
@onready var start_displaying = false

# For parent to enable/disable dialogue input checks
signal disable_monologue_input
signal enable_monologue_input

func _process(delta: float) -> void:
	if dialogue_label.visible_ratio == 1.0:
		start_displaying = false
	if start_displaying:
		dialogue_label.visible_characters += 1

func start_monologue():
	dialogue_label.text = monologue.monologue_dictionary["monologue"][0]["text"]
	display_characters()

func handle_monologue():
	# Error handling for if a player clicks too fast
	if dialogue_index > len(monologue.monologue_dictionary["monologue"]):
		return
	
	# Run any functions that the text has
	if monologue.monologue_dictionary["monologue"][dialogue_index].has("function"):
		if monologue.monologue_dictionary["monologue"][dialogue_index]["function"] == "end_monologue":
			monologue.end_monologue()
		
		# Potentially add anxiety increasing function here for when player has self-doubting thoughts
		
	else:
		dialogue_label.text = monologue.monologue_dictionary["monologue"][dialogue_index]["text"]
		display_characters()
		dialogue_index += 1

# Begins dialogue scrolling when dialogue advances
func display_characters():
	dialogue_label.visible_characters = 0
	start_displaying = true
