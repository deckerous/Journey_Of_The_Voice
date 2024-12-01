class_name Area
extends Node2D

@export var start_with_monologue: bool
@export var starting_monologue: PackedScene
@onready var monologues = $Monologues

@export var start_with_conversation: bool
@export var starting_conversation: PackedScene
@onready var conversations_root: Node2D = $ConversationsRoot
var available_conversations = null
var current_conversation = null

@onready var anxiety_effect = $AnxietyEffect
var curr_effect = null

@onready var minigames = $Minigames

@onready var area_animation_player = $AreaAnimationPlayer

@onready var vignette = preload("res://Anxiety Effects/Vignette/vignette.tscn")

func _ready():
	# Get reference to all clickable conversations in the area.
	available_conversations = conversations_root.get_children()
	for convo in available_conversations:
		# Connect each conversation to a remove function with extra functionality
		convo.started_conversation.connect(start_clickable_conversation.bind(convo))
	
	# Check if we enter the area with a starting monologue.
	# Error check, hide conversations, then instantiate provided monologue.
	if start_with_monologue and starting_monologue != null:
		for convo in available_conversations:
			convo.visible = false
		get_tree().paused = true
		await get_tree().create_timer(2.0).timeout
		begin_starting_monologue()
		get_tree().paused = false

func begin_starting_monologue():
	var inst = starting_monologue.instantiate()
	self.add_child.call_deferred(inst)
	if inst.has_following_conversation and inst.following_conversation != null:
		inst.finished_monologue.connect(go_to_next_convo.bind(inst.following_conversation))
		inst.finished_monologue.connect(hide_characters)

func go_to_next_monologue(monologue: PackedScene):
	var inst = monologue.instantiate()
	self.add_child(inst)
	if inst.has_following_conversation and inst.following_conversation != null:
		inst.finished_monologue.connect(go_to_next_convo.bind(inst.following_conversation))

func go_to_next_convo(conversation: PackedScene):
	var inst = conversation.instantiate()
	self.add_child(inst)
	inst.start_anxiety_effect.connect(instance_anxiety_effect)
	
	if inst.has_following_minigame and inst.following_minigame != null:
		# When this conversation is finsihed, instantiate next provided minigame
		inst.finished_conversation.connect(go_to_next_minigame.bind(inst.following_minigame))
		
	elif inst.has_following_conversation and inst.following_conversation != null:
		# When this conversation is finished, instantiate next provided conversation
		inst.finished_conversation.connect(go_to_next_convo.bind(inst.following_conversation))
		
	elif inst.has_following_monologue and inst.following_monologue != null:
		# When this conversation is finished, instantiate next provided monologue
		inst.finished_conversation.connect(go_to_next_monologue.bind(inst.following_monologue))
		
	else:
		# No following conversation or monologue, go to base area scene
		# inst.finished_conversation.connect(unhide_characters)
		inst.finished_conversation.connect(unhide_clickable_conversations)

func go_to_next_minigame(minigame: PackedScene):
	var inst = minigame.instantiate()
	self.add_child(inst)
	remove_anxiety_effect()
	inst.box_breathing_complete.connect(unhide_clickable_conversations)

func instance_anxiety_effect():
	var inst = vignette.instantiate()
	anxiety_effect.add_child(inst)
	curr_effect = inst

func remove_anxiety_effect():
	curr_effect.anim.play("fade_out")
	await curr_effect.anim.animation_finished
	curr_effect.queue_free()

func remove_from_available_conversations(convo: Conversation):
	var index = available_conversations.find(convo)
	available_conversations.remove(index)

func hide_characters():
	area_animation_player.play("fade_out_characters")

func unhide_characters():
	area_animation_player.play("fade_in_characters")

# Unhide all clickable conversations available to the player in the area.
func unhide_clickable_conversations():
	for convo in available_conversations:
			convo.visible = true
	area_animation_player.play("fade_in_clickable_conversations")

# Hide all clickable conversations available to the player in the area.
func hide_clickable_conversaitons(clicked_convo: Conversation = null):
	area_animation_player.play("fade_out_clickable_conversations")
	for convo in available_conversations:
		# if the clicked conversation is supplied and is the loop convo, don't hide.
		if clicked_convo != null and convo == clicked_convo:
			continue
		convo.visible = false

func start_clickable_conversation(convo: Conversation):
	hide_clickable_conversaitons(convo)
	convo.visible = true
	convo
	print("meow")
