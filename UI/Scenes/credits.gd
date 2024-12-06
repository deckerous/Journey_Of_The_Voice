extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const CREDITS_WHOLE_BAND = preload("res://Audio/songs/credits/credits-whole-band.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.play_sound_id(CREDITS_WHOLE_BAND, "music", GlobalAudio.Bus.MUSIC)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
