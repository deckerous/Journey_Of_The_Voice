extends Node2D

@export var music_turndown_id: String = ""
@export var num_to_win: int

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

	if num_to_win == -1:
		num_to_win = 10000
	
	while curr_words < num_words_on_screen && curr_words < num_to_win:
		_summon_word()
		
	# tweening manually to avoid the await
	GlobalAudio.tween_from_id(music_turndown_id, -80, 1.0)
	
func _end_self_talk():
	self.self_talk_complete.emit()
	GlobalAudio.tween_from_id(music_turndown_id, -15.0, 1.0)
	
	self.queue_free()

func _summon_word():
	curr_words += 1
	var random = RandomNumberGenerator.new()
	var posX = random.randf_range(-(centerX - 200), centerX - 200) 
	var posY = random.randf_range(-(centerY - 100), centerY - 100)
	var word = load(word_scene).instantiate()
	word.position = Vector2(posX, posY)
	word.collision_box = $Area2D
	word.word = possible_phrases[random.randi_range(0, possible_phrases.size() - 1)]
	add_child(word)
	
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if curr_words < num_to_win:
		_summon_word()
	else:
		_end_self_talk()
