extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const CREDITS_THEME = preload("res://Audio/songs/credits/credits-theme.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.play_sound_id(CREDITS_THEME, "music", GlobalAudio.Bus.MUSIC)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
