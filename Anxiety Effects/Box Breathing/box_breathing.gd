extends Node2D

@export var has_following_conversation: bool
@export var following_conversation: PackedScene

@export var show_tutorial = false
@export var game_background = false

@onready var hit_marker = $"Hit Marker"
@onready var bb_animation_player = $BBAnimationPlayer
@onready var breathing_sound = load("res://Audio/songs/breathe/breathe-theme.wav")
@onready var game_tutorial = $GameTutorial
@onready var the_b_gs: ColorRect = $TheBGs

var curr_music

signal mini_game_complete
signal box_breathing_started

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Access the player's save file and see if they have already seen the tutorial for box breathing.
	# If that is the case, hide the tutorial from being shown.
	var has_done_box_breathing = Player.save_file.get_value("player", "has_done_box_breathing") == null
	if !has_done_box_breathing:
		game_tutorial.visible = false
	else:
		# Check now exists for later instantiations of box breathing
		Player.add_check("has_done_box_breathing")
	
	if game_background:
		the_b_gs.visible = true
	
	# Flag which forces the tutorial, used for access from notebook
	if show_tutorial:
		game_tutorial.visible = true
	
	bb_animation_player.play("fade_in")
	
	var tweener = get_tree().create_tween()
	curr_music = GlobalAudio.get_music_stream().stream
	
	# Position button in screen center
	var centerX = get_viewport_rect().size.x / 2
	var centerY = get_viewport_rect().size.y / 2
	
	position = Vector2(centerX, centerY)
	game_tutorial.position = Vector2(-centerX,-centerY)
	
	hit_marker.success_number_reached.connect(end_box_breathing)
	
	# tweening manually to avoid the await
	var player = GlobalAudio.play_sound_id(breathing_sound, "breathing-theme", GlobalAudio.Bus.MUSIC)
	player.volume_db = -15

func end_box_breathing():
	self.mini_game_complete.emit()
	bb_animation_player.play("fade_out")
	var player = GlobalAudio.play_sound_id(curr_music, "music", GlobalAudio.Bus.MUSIC)
	player.volume_db = -80
	GlobalAudio.stop_stream_from_id("breathing-theme")
	GlobalAudio.tween_from_id("music", -15, 1.0)
	await bb_animation_player.animation_finished
	self.queue_free()
