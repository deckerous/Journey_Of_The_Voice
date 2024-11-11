class_name Monologue
extends Node2D

# .json file that the dialogue for the monologue will be read from
@export_file("*json") var monologue_file: String

@onready var monologue_ui: CanvasLayer = $MonologueUI

# Reference for controlling fade in and fade out
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var monologue_click_area: Area2D = $MonologueClickArea
@onready var monologue_collision_shape_2d: CollisionShape2D = $MonologueClickArea/MonologueCollisionShape2D

# Holds dialogue text and other attributes accessed via keys
var monologue_dictionary

func _ready() -> void:
	# Load in dialogue when instantiated
	load_dialogue()
	disable_monologue_click_collision()
	
	# Connect signal for handling dialogue with click
	monologue_click_area.input_event.connect(on_monologue_click)
	
	monologue_ui.disable_monologue_input.connect(disable_monologue_click_collision)
	monologue_ui.enable_monologue_input.connect(enable_monologue_click_collision)
	
	animation_player.animation_finished.connect(display_dialogue)
	animation_player.play("fade_in")

# For advancing monologue
func on_monologue_click(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			monologue_ui.handle_monologue()

# Initialize dialogue dictionary with provided .json file
func load_dialogue():
	if FileAccess.file_exists(monologue_file):
		var file = FileAccess.open(monologue_file, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		monologue_dictionary = test_json_conv.get_data()

func display_dialogue(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		monologue_collision_shape_2d.disabled = false
		monologue_ui.handle_monologue()

func end_monologue():
	disable_monologue_click_collision()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	self.queue_free()

func enable_monologue_click_collision():
	monologue_collision_shape_2d.disabled = false

func disable_monologue_click_collision():
	monologue_collision_shape_2d.disabled = true
