extends Node2D

@export var shake_factor = 3.0
@export var word_scale = 1.5
@export var collision_box: Area2D
@export var word = "temp"
@export var clickable: bool = true

@onready var text = $RichTextLabel
@onready var collision: Area2D = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animator = $AnimationPlayer

const SPEED = 150
@onready var has_mouse = false
@onready var cease = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape_2d.disabled = !clickable
	var rng = RandomNumberGenerator.new()
	rotation = deg_to_rad(rng.randf_range(-30, 30))
	var scale_num = word_scale * rng.randf_range(0.9, 1.1)
	scale = Vector2(scale_num, scale_num)
	text.text = "[center][shake rate=20.0 level=" + str(shake_factor * rng.randf_range(0.5, 2)) + " connected=1]" + word + "[/shake][/center]"
	
	animator.play("fade_in")

func _process(delta: float) -> void:
	if Input.is_action_pressed("click") && has_mouse && !cease:
		global_position = global_position.lerp(get_global_mouse_position(), SPEED * delta)
	elif cease:
		animator.play("fade_out")
		await animator.animation_finished
		queue_free()
		
func _word_touched(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if collision_box == area:
		cease = true

func _on_area_2d_mouse_entered() -> void:
	has_mouse = true

func _on_area_2d_mouse_exited() -> void:
	has_mouse = false
