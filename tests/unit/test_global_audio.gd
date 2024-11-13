extends GutTest
func before_each():
	GlobalAudio.set_global_vol(1)
	GlobalAudio.play_sound_id(load("res://Audio/songs/bar/bar-theme.wav"), "bar")
	GlobalAudio.play_sound_id(load("res://Audio/songs/beep/beep-theme.wav"), "beep")
	# await get_tree().create_timer(1.0).timeout
	gut.p("ran setup")

func after_each():
	GlobalAudio.stop_stream_from_id("bar")
	GlobalAudio.stop_stream_from_id("beep")
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test_get_sound_from_id():
	assert_not_null(GlobalAudio.get_stream_from_id("bar"))
	assert_not_null(GlobalAudio.get_stream_from_id("beep"))
	
func test_set_sound_from_id():
	var asp: AudioStreamPlayer = GlobalAudio.get_stream_from_id("bar")
	asp.volume_db = linear_to_db(0.5)
	
	assert_almost_eq(GlobalAudio.get_stream_from_id("bar").volume_db, linear_to_db(0.5), 0.01)
	
# func test_set_global_audio():
#	GlobalAudio.set_global_vol(3)
#	
#	await get_tree().create_timer(0.2).timeout
#	assert_almost_eq(GlobalAudio.get_stream_from_id("bar").volume_db, linear_to_db(0.03), 0.01)
#	assert_almost_eq(GlobalAudio.get_stream_from_id("beep").volume_db, linear_to_db(0.03), 0.01)
	
