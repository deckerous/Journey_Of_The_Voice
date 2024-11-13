class_name Monologue
extends Node2D

# .json file that the dialogue for the monologue will be read from
@export_file("*json") var monologue_file: String

@onready var monologue_ui: CanvasLayer = $MonologueUI

# Reference for controlling fade in and fade out
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Reference to nodes that receive click input
@onready var monologue_click_area: Area2D = $MonologueClickArea
@onready var monologue_collision_shape_2d: CollisionShape2D = $MonologueClickArea/MonologueCollisionShape2D

# For when a conversation immediately follows a monologue without player input
@export var has_following_conversation: bool = false
@export var following_conversation: PackedScene

# Holds dialogue text and other attributes accessed via keys
var monologue_dictionary

signal finished_monologue

func _ready() -> void:
	# Load in dialogue when instantiated
	load_dialogue()
	
	# Connect signal for handling dialogue with click
	monologue_click_area.input_event.connect(on_monologue_click)
	
	# For MonolgueUI to tell Monologue when tot disable/enable click collision
	monologue_ui.disable_monologue_input.connect(disable_monologue_click_collision)
	monologue_ui.enable_monologue_input.connect(enable_monologue_click_collision)
	
	# When the fade_in animation finsihes playing, start displaying the dialogue.
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
	# Connected to signal in animation_player when an animation finishes.
	# Cnim_name is the animation that is finished.
	if anim_name == "fade_in":
		monologue_collision_shape_2d.disabled = false
		monologue_ui.handle_monologue()

func end_monologue():
	# When the player exhausts monologue, play fade out and delete from the scene.
	# Wait for the signal for the animation to be finished first before deleting.
	disable_monologue_click_collision()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	self.emit_signal("finished_monologue")
	self.queue_free()

func enable_monologue_click_collision():
	monologue_collision_shape_2d.disabled = false

func disable_monologue_click_collision():
	monologue_collision_shape_2d.disabled = true
