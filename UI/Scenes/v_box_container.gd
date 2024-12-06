extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start button is selected by default
	$"CenterContainer - Start/StartButton".grab_focus()
