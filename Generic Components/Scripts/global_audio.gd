extends Node

@onready var global_vol = 100

func set_global_vol(val):
	global_vol = val
	for audio in get_children():
		if audio is AudioStreamPlayer:
			audio.set("volume_db", linear_to_db(global_vol / 100))

func play_sound(audio_stream: AudioStream) -> AudioStreamPlayer:
	var temp_stream = AudioStreamPlayer.new()
	temp_stream.stream = audio_stream
	temp_stream.autoplay = true
	temp_stream.volume_db = linear_to_db(global_vol/100)
	temp_stream.finished.connect(finished)
	
	add_child(temp_stream)
	return temp_stream
	
func play_sound_id(audio_stream: AudioStream, id: String) -> AudioStreamPlayer:
	var temp_stream = play_sound(audio_stream)
	temp_stream.name = id
	
	return temp_stream
	
func get_stream_from_id(id: String) -> AudioStreamPlayer:
	return get_node("/root/GlobalAudio/" + id)

func stop_stream_from_id(id: String):
	remove_child(get_stream_from_id(id))

func finished():
	for audio in get_children():
		if audio is AudioStreamPlayer:
			if !audio.playing:
				remove_child(audio)
				return
			
