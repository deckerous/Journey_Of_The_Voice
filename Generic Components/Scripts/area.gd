class_name Area
extends Node2D

@export var start_with_monologue: bool
@export var starting_monologue: PackedScene

@export var start_with_conversation: bool
@export var starting_conversation: PackedScene
@onready var conversations_root: Node2D = $ConversationsRoot
var available_conversations = null
var current_conversation = null

@onready var anxiety_effect_root = $AnxietyEffectRoot
var curr_effect = null

@onready var conversation_instances = $ConversationInstances
@onready var minigames = $Minigames

@onready var interactables = $Interactables
@onready var interactable_insts
@onready var interables_available = false

@onready var area_animation_player = $AreaAnimationPlayer

@onready var vignette = preload("res://Anxiety Effects/Vignette/vignette.tscn")

@onready var anxiety_effects = {
	"vignette": load("res://Anxiety Effects/Vignette/vignette.tscn"),
	"self_talk": load("res://Anxiety Effects/Self Talk/self_talk_effect.tscn"),
	"eye_contact": load("res://Anxiety Effects/Eye Contact/eye_contact_effect.tscn")
}

@onready var interactables_exist = false
signal interactable_now_visible
signal interactable_now_invisible

signal area_complete

func _ready():
	# Get reference to all clickable conversations in the area.
	available_conversations = conversations_root.get_children()
	for convo in available_conversations:
		# Connect each conversation to a remove function with extra functionality
		convo.started_conversation.connect(start_clickable_conversation.bind(convo))
	
	# Check if we enter the area with a starting monologue.
	# Error check, hide conversations, then instantiate provided monologue.
	if start_with_monologue and starting_monologue != null:
		conversations_root.visible = false
		get_tree().paused = true
		await get_tree().create_timer(2.0).timeout
		go_to_next_monologue(starting_monologue)
		get_tree().paused = false
	elif start_with_conversation and starting_conversation != null:
		conversations_root.visible = false
		get_tree().paused = true
		await get_tree().create_timer(2.0).timeout
		go_to_next_convo(starting_conversation)
		get_tree().paused = false
	
	# Interactables in this scene, save reference to them when enabling them when
	# the player is out of a convo, mono, or minigame.
	if len(interactables.get_children()) > 0:
		interactables_exist = true
		interactable_insts = interactables.get_children()
		for i in interactable_insts:
			i.now_visible.connect(func(): interactable_now_visible.emit())
			i.now_invisible.connect(func(): interactable_now_invisible.emit())

func go_to_next_monologue(monologue: PackedScene):
	var inst = monologue.instantiate()
	self.add_child(inst)
	
	$UICanvas/UIMenu.menu_entered.connect(inst.disable_monologue_click_collision)
	$UICanvas/UIMenu.menu_exited.connect(inst.enable_monologue_click_collision)
	
	if inst.hide_characters_after:
		inst.finished_monologue.connect(hide_characters)
	
	if inst.end_of_chapter:
		# When a conversation has this check, unhide button to go to next chapter
		inst.finished_monologue.connect(allow_traversal_to_next_chapter)
	
	if inst.has_following_conversation and inst.following_conversation != null:
		inst.finished_monologue.connect(go_to_next_convo.bind(inst.following_conversation))
	else:
		# No following conversation or monologue, go to base area scene
		if conversations_root.get_child_count() > 0:
			inst.finished_monologue.connect(fade_in_clickable_conversations)
		if interactables_exist:
			inst.finished_monologue.connect(enable_interactables)

func go_to_next_convo(conversation: PackedScene):
	var inst = conversation.instantiate()
	#conversation_instances.add_child(inst)
	conversation_instances.call_deferred("add_child", inst)
	
	$UICanvas/UIMenu.menu_entered.connect(inst.disable_dialogue_click_collision)
	$UICanvas/UIMenu.menu_exited.connect(inst.enable_dialogue_click_collision)
	
	inst.start_anxiety_effect.connect(instance_anxiety_effect)
	if inst.end_anxiety_effect:
		inst.finished_conversation.connect(remove_anxiety_effect)
	
	if inst.hide_characters_after:
		inst.finished_conversation.connect(hide_characters)
	
	if inst.end_of_chapter:
		# When a conversation has this check, unhide button to go to next chapter
		inst.finished_conversation.connect(allow_traversal_to_next_chapter)
	
	if inst.has_following_minigame and inst.following_minigame != null:
		# When this conversation is finsihed, instantiate next provided minigame
		inst.finished_conversation.connect(go_to_next_minigame.bind(inst.following_minigame))
	
	elif inst.has_following_conversation and inst.following_conversation != null:
		# When this conversation is finished, instantiate next provided conversation
		inst.finished_conversation.connect(go_to_next_convo.bind(inst.following_conversation))
		
		# Also connect the failure conversation if there is one
		if inst.has_failure_conversation and inst.failure_conversation != null:
			# When this conversation is finished, instantiate the following failure convo if there is one
			inst.failed_conversation.connect(go_to_next_convo.bind(inst.failure_conversation))
		
	elif inst.has_following_conversation and inst.following_conversation_path != null:
		var convo_inst = load(inst.following_conversation_path)
		inst.finished_conversation.connect(go_to_next_convo.bind(convo_inst))
	
	elif inst.has_following_monologue and inst.following_monologue != null:
		# When this conversation is finished, instantiate next provided monologue
		inst.finished_conversation.connect(go_to_next_monologue.bind(inst.following_monologue))
		
	else:
		# No following conversation or monologue, go to base area scene
		if conversations_root.get_child_count() > 0:
			inst.finished_conversation.connect(fade_in_clickable_conversations)
		if interactables_exist:
			inst.finished_conversation.connect(enable_interactables)

func go_to_next_minigame(minigame: PackedScene):
	var inst = minigame.instantiate()
	minigames.add_child(inst)
	if len(anxiety_effect_root.get_children()) > 0:
		remove_anxiety_effect()
	
	if inst.has_following_conversation:
		inst.mini_game_complete.connect(go_to_convo_after_minigame_outcome.bind(inst))
	else:
		# No following conversation or monologue, go to base area scene
		if conversations_root.get_child_count() > 0:
			inst.mini_game_complete.connect(fade_in_clickable_conversations)
		if interactables_exist:
			inst.mini_game_complete.connect(enable_interactables)

func go_to_convo_after_minigame_outcome(minigame):
	go_to_next_convo(minigame.following_conversation)

func instance_anxiety_effect(anxiety_effect: String):
	var anxiety_effect_scene = anxiety_effects.get(anxiety_effect)
	var inst = anxiety_effect_scene.instantiate()
	anxiety_effect_root.add_child(inst)

func remove_anxiety_effect():
	for effect in anxiety_effect_root.get_children():
		if effect.has_node("AnimationPlayer"):
			effect.animation_player.play("fade_out")
			await effect.animation_player.animation_finished
		effect.queue_free()

func hide_characters():
	area_animation_player.play("fade_out_characters")

func unhide_characters():
	area_animation_player.play("fade_in_characters")

# Enable available interactables for the player to click.
func enable_interactables():
	for i in interactable_insts:
		i.enable_button()

# Disable available interactables for the player to click.
func disable_interactables():
	for i in interactable_insts:
		i.disable_button()

# Unhide all clickable conversations available to the player in the area.
func fade_in_clickable_conversations():
	available_conversations = conversations_root.get_children()
	if len(available_conversations) > 0:
		conversations_root.visible = true
		for convo in available_conversations:
			if convo is Conversation:
				convo.fade_in_convo()
				if convo.has_following_conversation and convo.following_conversation != null:
					convo.finished_conversation.connect(go_to_next_convo.bind(convo.following_conversation))

# Hide all clickable conversations available to the player in the area.
func fade_out_clickable_conversaitons(clicked_convo: Conversation = null):
	for convo in available_conversations:
		if convo == clicked_convo:
			continue
		elif convo != null and convo is Conversation:
			convo.fade_out_convo()

func start_clickable_conversation(convo: Conversation):
	if convo.end_of_chapter:
		# When a conversation has this check, unhide button to go to next chapter
		convo.finished_conversation.connect(allow_traversal_to_next_chapter)
	
	fade_out_clickable_conversaitons(convo)
	convo.visible = true

func allow_traversal_to_next_chapter():
	area_complete.emit()
