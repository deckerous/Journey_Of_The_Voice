extends Node

@onready var global_vol = 100

func set_global_vol(val):
	global_vol = val
	for audio in get_children():
		if audio is AudioStreamPlayer:
			audio.volume_db = linear_to_db(global_vol/100)

func play_sound(audio_stream: AudioStream):
	var temp_stream = AudioStreamPlayer.new()
	temp_stream.stream = audio_stream
	temp_stream.autoplay = true
	temp_stream.volume_db = linear_to_db(global_vol/100)
	temp_stream.finished.connect(finished)
	
	add_child(temp_stream)

func finished():
	for audio in get_children():
		if audio is AudioStreamPlayer:
			if !audio.playing:
				remove_child(audio)
				return
			
