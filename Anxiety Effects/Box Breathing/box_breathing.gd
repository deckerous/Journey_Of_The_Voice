extends Node2D

@onready var hit_marker = $"Hit Marker"
@onready var bb_animation_player = $BBAnimationPlayer
@onready var breathing_sound = load("res://Audio/songs/breathe/breathe-theme.wav")
@onready var game_tutorial = $GameTutorial

signal box_breathing_complete
signal box_breathing_started

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Access the player's save file and see if they have already seen the tutorial for box breathing.
	# If that is the case, hide the tutorial from being shown.
	var has_done_box_breathing = Player.save_file.get_value("Player", "has_done_box_breathing") == null
	print(has_done_box_breathing)
	if !has_done_box_breathing:
		game_tutorial.visible = false
	
	bb_animation_player.play("fade_in")
	
	var tweener = get_tree().create_tween()
	var bar_audio = GlobalAudio.get_stream_from_id("bar-theme")
	
	# Position button in screen center
	var centerX = get_viewport_rect().size.x / 2
	var centerY = get_viewport_rect().size.y / 2
	
	position = Vector2(centerX, centerY)
	game_tutorial.position = Vector2(-centerX,-centerY)
	
	hit_marker.success_number_reached.connect(end_box_breathing)
	
	# tweening manually to avoid the await
	await tweener.tween_property(bar_audio, "volume_db", -80, 2.0)
	var player = GlobalAudio.play_sound_id(breathing_sound, "breathing-theme")
	GlobalAudio.tween_from_id("breathing-theme", -15, 3.0)

func end_box_breathing():
	self.box_breathing_complete.emit()
	bb_animation_player.play("fade_out")
	GlobalAudio.tween_from_id("breathing-theme", -80.0, 0.5)
	await bb_animation_player.animation_finished
	GlobalAudio.stop_stream_from_id("breathing_sound")
	GlobalAudio.tween_from_id("bar-theme", -15.0, 1.0)
	
	self.queue_free()
