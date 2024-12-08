extends Area

@onready var music: AudioStreamWAV = load("res://Audio/songs/wave/wave-theme.wav")
@onready var parentChapter: Chapter = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play the (bar theme)
	super()
	var stream = GlobalAudio.play_sound_id(music, "wave-theme", GlobalAudio.Bus.MUSIC)
	stream.volume_db = -15
	
	# Connect to a signal for when the next chapter button is clicked
	parentChapter.clicked.connect(_stop_music)


func _stop_music() -> void:
	GlobalAudio.stop_stream_from_id("wave-theme")
