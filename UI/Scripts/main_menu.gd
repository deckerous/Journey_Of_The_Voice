extends Node2D

@onready var music: AudioStreamWAV = load("res://Audio/songs/beep/beep-theme.wav")

func _ready():
	var stream = GlobalAudio.play_sound(music)
	stream.volume_db = -15
