class_name Area
extends Node2D

@export var start_with_monologue: bool
@export var starting_monologue: PackedScene
@onready var monologues = $Monologues

@export var starting_conversation: PackedScene
@onready var conversations = $Conversations

@onready var anxiety_effect = $AnxietyEffect
var curr_effect = null

@onready var minigames = $Minigames

@onready var area_animation_player = $AreaAnimationPlayer

@onready var vignette = preload("res://Anxiety Effects/Vignette/vignette.tscn")

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
	var inst = conversation.instantiate()
	conversations.add_child(inst)
	inst.start_anxiety_effect.connect(instance_anxiety_effect)
	
	if inst.has_following_minigame and inst.following_minigame != null:
		inst.finished_conversation.connect(play_minigame.bind(inst.following_minigame))
		return
	
	if inst.has_following_conversation and inst.following_conversation != null:
		inst.finished_conversation.connect(go_to_next_convo.bind(inst.following_conversation))
	elif !inst.has_following_conversation:
		inst.finished_conversation.connect(unhide_characters)

func play_minigame(minigame: PackedScene):
	#await get_tree().create_timer(1.0).timeout
	var inst = minigame.instantiate()
	self.add_child(inst)
	remove_anxiety_effect()
	inst.box_breathing_complete.connect(to_be_continued)

func go_to_next_drummer_convo(conversation: PackedScene):
	var sc_node = conversation.instantiate()
	conversations.add_child(sc_node)

func instance_anxiety_effect():
	var inst = vignette.instantiate()
	anxiety_effect.add_child(inst)
	curr_effect = inst

func remove_anxiety_effect():
	curr_effect.anim.play("fade_out")
	await curr_effect.anim.animation_finished
	curr_effect.queue_free()

func hide_characters():
	area_animation_player.play("fade_out_characters")

func unhide_characters():
	area_animation_player.play("fade_in_characters")

func to_be_continued():
	area_animation_player.play("fade_in_tbc")
