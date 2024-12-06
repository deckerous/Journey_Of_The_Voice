extends Button

@onready var hover_sound: AudioStreamWAV = load("res://Audio/sound-effects/shick-sound.wav")
@onready var pressed_sound: AudioStreamWAV = load("res://Audio/sound-effects/shika-sha-sound.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pressed_callable = Callable(GlobalAudio, "play_sound")
	var hover_callable = Callable(GlobalAudio, "play_sound")
	focus_entered.connect(hover_callable.bind(hover_sound))
	pressed.connect(pressed_callable.bind(pressed_sound))
