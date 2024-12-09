extends Node

enum Bus {
	SFX,
	MUSIC,
}

var master_vol = 100
var sfx_vol = 100
var music_vol = 100
var current_music_stream = null

func set_master_vol(level: int):
	master_vol = level
	update_bus()

func set_sfx_vol(level: int):
	sfx_vol = level
	update_bus()

func set_music_vol(level: int):
	music_vol = level
	update_bus()
	
func update_bus():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol * 0.01 * master_vol * 0.01))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol * 0.01 * master_vol * 0.01))

func play_sound(audio_stream: AudioStream, bus: Bus = Bus.SFX, pitch_scale: float = 1) -> AudioStreamPlayer:
	var temp_stream = AudioStreamPlayer.new()
	temp_stream.stream = audio_stream
	match bus:
		Bus.SFX:
			temp_stream.bus = &"SFX"
		Bus.MUSIC:
			if current_music_stream != null:
				stop_stream_from_id(current_music_stream.name)
			current_music_stream = temp_stream
			temp_stream.bus = &"Music"
	temp_stream.pitch_scale = pitch_scale
	temp_stream.autoplay = true
	temp_stream.finished.connect(finished)
	
	add_child(temp_stream)
	return temp_stream
	
func play_sound_id(audio_stream: AudioStream, id: String, bus: Bus = Bus.SFX, pitch_scale: float = 1) -> AudioStreamPlayer:
	var temp_stream = play_sound(audio_stream, bus, pitch_scale)
	temp_stream.name = id
	
	return temp_stream
	
func get_stream_from_id(id: String) -> AudioStreamPlayer:
	return get_node_or_null("/root/GlobalAudio/" + id)

func stop_stream_from_id(id: String):
	remove_child(get_stream_from_id(id))

func get_music_stream() -> AudioStreamPlayer:
	return current_music_stream

func tween_from_id(id: String, value: float, duration: float):
	var audio = get_stream_from_id(id)
	if audio != null:
		var tweener: Tween = create_tween()
		tweener.tween_property(audio, "volume_db", value, duration)
		print(tweener.get_loops_left())

func finished():
	for audio in get_children():
		if audio is AudioStreamPlayer:
			if !audio.playing:
				remove_child(audio)
				return
