extends Node

@onready var label = $CanvasLayer/RichTextLabel

func add_to_archive(character, text):
	if character == "":
		monologue_to_archive(text)
		return
	
	label.text += "[b]" + character + ":[/b] " + text + "\n\n"
	
func monologue_to_archive(text):
	label.text += "[b]Narrator:[/b] " + text + "\n\n"
	
func clear_archive():
	label.text = ""

func visible(val):
	$CanvasLayer.visible = val
