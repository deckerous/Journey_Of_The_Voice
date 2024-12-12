extends Node2D

@onready var cam = $Camera2D
@onready var animation_player = $AnimationPlayer

@export var music_turndown_id: String
@export var duration = 10
@export var speed = 75
@export var leniency = 200
var base_speed

@export var max_zoom: Vector2 = Vector2(1.3, 1.3)
@export var zoom_speed: Vector2 = Vector2(0.005, 0.005)

var distract_dir: Vector2
var initial_pos: Vector2
@onready var can_move = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = Vector2(0, 0)
	initial_pos = cam.position
	generate_new_distract_dir()
	animation_player.animation_changed.connect(reset_camera_position)

func _physics_process(delta: float) -> void:
	if can_move:
		cam.position += distract_dir.normalized() * speed * delta
		speed += 1
		
		if cam.zoom < max_zoom:
			cam.zoom += zoom_speed
		
		var vector_from_start = cam.position - initial_pos
		var dist_from_start = vector_from_start.length()
		if (dist_from_start > leniency):
			speed = 0

func reset_camera_position():
	can_move = false

func generate_new_distract_dir():
	var rand = RandomNumberGenerator.new()
	distract_dir = Vector2(rand.randf_range(-1, 1), rand.randf_range(0.5, 1))
