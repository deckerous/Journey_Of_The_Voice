extends Node2D

@onready var cam = $Camera2D
@onready var timer = $Timer

#TODO: Attach eye contact minigame music
@onready var minigame_music = load("res://Audio/songs/wave/wave-theme.wav")

@export var music_turndown_id: String
@export var duration = 10
@export var speed = 75
@export var leniency = 200
var base_speed

var distract_dir: Vector2
var initial_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = Vector2(0, 0)
	initial_pos = cam.position
	
	GlobalAudio.tween_from_id(music_turndown_id, -80, 1.0)
	GlobalAudio.play_sound_id(minigame_music, "eye_contact", GlobalAudio.Bus.MUSIC)
	GlobalAudio.get_stream_from_id("eye_contact").volume_db = -80
	GlobalAudio.tween_from_id("eye_contact", -15, 1.0)
	
	generate_new_distract_dir()

func _physics_process(delta: float) -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#speed = base_speed
		#var mouse_pos = get_viewport().get_mouse_position()
		#var reversed_pos = Vector2(get_viewport().size) - mouse_pos
		#
		#cam.position = cam.position.lerp(reversed_pos, delta)
		#generate_new_distract_dir()
	#else:
	cam.position += distract_dir.normalized() * speed * delta
	speed += 1
	
	var vector_from_start = cam.position - initial_pos
	var dist_from_start = vector_from_start.length()
	if (dist_from_start > leniency):
		speed = 0

func generate_new_distract_dir():
	var rand = RandomNumberGenerator.new()
	distract_dir = Vector2(rand.randf_range(-1, 1), rand.randf_range(-1, 1))

func cleanup():
	GlobalAudio.tween_from_id("eye_contact", -80, 1.0)
	GlobalAudio.tween_from_id(music_turndown_id, -20, 1.0)
	
	self.queue_free()
