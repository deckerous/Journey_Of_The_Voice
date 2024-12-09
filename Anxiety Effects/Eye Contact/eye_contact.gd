extends Node2D

signal failed_game
signal succeeded_game

@onready var cam = $Camera2D
@onready var timer = $Timer
@onready var the_b_gs: ColorRect = $TheBGs
@onready var animation_player = $AnimationPlayer

#TODO: Attach eye contact minigame music
@onready var minigame_music = load("res://Audio/songs/wave/wave-theme.wav")
@onready var character: Sprite2D = $Character

@onready var successful_convo: PackedScene = load("res://Chapters/Chapter 7/Conversations/ch_7_5_bassist_2_successful_convo.tscn")
@onready var failed_convo: PackedScene = load("res://Chapters/Chapter 7/Conversations/ch_7_5_bassist_2_failed_convo.tscn")

@export var has_following_conversation: bool
@onready var following_conversation: PackedScene

@export var duration = 10
@export var speed = 75
@export var leniency = 200
@export var show_tutorial = false
@export var game_background = false
var base_speed

@export var max_zoom: Vector2 = Vector2(1.3, 1.3)
@export var zoom_speed: Vector2 = Vector2(0.005, 0.005)

var distract_dir: Vector2
var initial_pos: Vector2

var curr_music

signal mini_game_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if game_background:
		the_b_gs.visible = true
		character.visible = true
		
	self.position = Vector2(0, 0)
	initial_pos = cam.position
	
	curr_music = GlobalAudio.get_music_stream().stream
	var music: AudioStreamPlayer = GlobalAudio.play_sound_id(minigame_music, "eye_contact", GlobalAudio.Bus.MUSIC)
	music.volume_db = -80
	GlobalAudio.tween_from_id("eye_contact", -15, 1.0)
	
	set_physics_process(false)
	
	var has_done_eye_contact = Player.save_file.get_value("player", "has_done_eye_contact") == null
	if !has_done_eye_contact and !show_tutorial:
		$GameTutorial2.visible = false
		_on_tutorial_end()

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		speed = base_speed
		var mouse_pos = get_viewport().get_mouse_position()
		var reversed_pos = Vector2(get_viewport().size) - mouse_pos
		
		cam.position = cam.position.lerp(reversed_pos, delta)
		generate_new_distract_dir()
	else:
		cam.position += distract_dir.normalized() * speed * delta
		speed += 1
	
	if cam.zoom < max_zoom:
		cam.zoom += zoom_speed
	
	var vector_from_start = cam.position - initial_pos
	var dist_from_start = vector_from_start.length()
	if (dist_from_start > leniency):
		following_conversation = failed_convo
		failed_game.emit()
		cleanup()

func generate_new_distract_dir():
	var rand = RandomNumberGenerator.new()
	distract_dir = Vector2(rand.randf_range(-1, 1), rand.randf_range(-1, 1))

func cleanup():
	mini_game_complete.emit()
	var player = GlobalAudio.play_sound_id(curr_music, "music", GlobalAudio.Bus.MUSIC)
	player.volume_db = -80
	GlobalAudio.stop_stream_from_id("eye_contact")
	GlobalAudio.tween_from_id("music", -15, 1.0)
	self.queue_free()

func _on_timer_timeout() -> void:
	# Check now exists for later instantiations of box breathing
	Player.add_check("has_done_eye_contact")
	following_conversation = successful_convo
	succeeded_game.emit()
	cleanup()

func _on_tutorial_end() -> void:
	timer.wait_time = duration
	timer.start()
	
	base_speed = speed
	generate_new_distract_dir()
	
	set_physics_process(true)
