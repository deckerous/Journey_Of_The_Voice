extends Node2D

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

@onready var word_scene = "res://Anxiety Effects/Self Talk/interactable_word.tscn"
@onready var centerX = get_viewport_rect().size.x / 2
@onready var centerY = get_viewport_rect().size.y / 2

signal self_talk_complete

const num_words_on_screen = 6
const possible_phrases = ["I don't belong here......", "What did I just say?", "They must be annoyed...", "I'm a nuisance",
	"This is very not poggers", "I can't do this", "I'm gonna fail", "What should I do", "Oh my gyatt"]

@onready var curr_words = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(centerX, centerY)
	timer.timeout.connect(_summon_word)

func _summon_word():
	curr_words += 1
	var random = RandomNumberGenerator.new()
	var posX = random.randf_range(-(centerX - 200), centerX - 200) 
	var posY = random.randf_range(-(centerY - 100), centerY - 100)
	var word = load(word_scene).instantiate()
	
	word.z_index = 5
	word.clickable = false
	word.position = Vector2(posX, posY)
	word.collision_box = $Area2D
	word.word = possible_phrases[random.randi_range(0, possible_phrases.size() - 1)]
	call_deferred("add_child", word)
