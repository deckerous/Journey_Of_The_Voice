class_name Area
extends Node2D

@export var start_with_monologue: bool
@export var starting_monologue: PackedScene
@onready var monologues = $Monologues

@export var starting_conversation: PackedScene
@onready var conversations = $Conversations

@onready var area_animation_player = $AreaAnimationPlayer

func _ready():
	# Begin area with starting monologue.
	# Error check then instantiate provided monologue.
	if start_with_monologue and starting_monologue != null:
		get_tree().paused = true
		await get_tree().create_timer(1.5).timeout
		var sm_node = starting_monologue.instantiate()
		monologues.add_child.call_deferred(sm_node)
		sm_node.finished_monologue.connect(begin_starting_conversation)
		sm_node.finished_monologue.connect(hide_characters)
		get_tree().paused = false

func begin_starting_conversation():
	var sc_node = starting_conversation.instantiate()
	conversations.add_child(sc_node)
	sc_node.finished_conversation.connect(go_to_next_monologue.bind(sc_node.following_monologue))

func go_to_next_monologue(monologue: PackedScene):
	var mono = monologue.instantiate()
	monologues.add_child(mono)
	mono.finished_monologue.connect(go_to_next_convo.bind(mono.following_conversation))

func go_to_next_convo(conversation: PackedScene):
	var sc_node = conversation.instantiate()
	conversations.add_child(sc_node)

func hide_characters():
	area_animation_player.play("fade_out_characters")
