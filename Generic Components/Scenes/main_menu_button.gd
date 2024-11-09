extends Button

@export var scene: PackedScene

@onready var hover_sound: AudioStreamPlayer2D = $HoverSound
@onready var pressed_sound: AudioStreamPlayer2D = $PressedSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_entered.connect(hover_sound.play)
	pressed.connect(pressed_sound.play)
	pressed.connect(go_to_scene)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func go_to_scene():
	get_tree().change_scene_to_packed(scene)
