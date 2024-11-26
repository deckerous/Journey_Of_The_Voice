extends Node

@onready var cam = $Camera2D

@export var speed = 75
var base_speed

var distract_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_speed = speed
	generate_new_distract_dir()

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
		
func generate_new_distract_dir():
	var rand = RandomNumberGenerator.new()
	distract_dir = Vector2(rand.randf_range(-1, 1), rand.randf_range(-1, 1))
