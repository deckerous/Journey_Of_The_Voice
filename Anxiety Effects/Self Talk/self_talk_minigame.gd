extends Node2D

@export var num_to_win: int
@export var show_tutorial = false
@export var has_following_conversation: bool
@export var following_conversation: PackedScene
@export var game_background = false

#TODO: change to self_talk music
@onready var the_b_gs: ColorRect = $TheBGs
@onready var minigame_music = load("res://Audio/songs/breathe/breathe-theme.wav")
@onready var word_scene = "res://Anxiety Effects/Self Talk/interactable_word.tscn"
@onready var centerX = get_viewport_rect().size.x / 2
@onready var centerY = get_viewport_rect().size.y / 2

signal mini_game_complete

const num_words_on_screen = 6
const possible_phrases = ["I don't belong here......", "What did I just say?", "They must be annoyed...", "I'm a nuisance",
	"This is very not poggers", "I can't do this", "I'm gonna fail", "What should I do", "Oh my gyatt"]

@onready var curr_words = 0

var curr_music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if game_background:
		the_b_gs.visible = true
	position = Vector2(centerX, centerY)
	
	# tweening manually to avoid the await
	curr_music = GlobalAudio.get_music_stream().stream
	var music: AudioStreamPlayer = GlobalAudio.play_sound_id(minigame_music, "self_talk", GlobalAudio.Bus.MUSIC)
	music.volume_db = -80
	GlobalAudio.tween_from_id("self_talk", -15, 1.0)
	
	var has_done_self_talk = Player.save_file.get_value("player", "has_done_self_talk") == null
	if !has_done_self_talk:
		if !show_tutorial:
			$GameTutorial.visible = false
			_on_game_tutorial_finished_tutorial()

func _end_self_talk():
	# Check now exists for later instantiations of self_talk
	Player.add_check("has_done_self_talk")
	self.mini_game_complete.emit()
	var player = GlobalAudio.play_sound_id(curr_music, "music", GlobalAudio.Bus.MUSIC)
	player.volume_db = -80
	GlobalAudio.stop_stream_from_id("self_talk")
	GlobalAudio.tween_from_id("music", -15, 1.0)
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
	call_deferred("add_child", word)
	
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if curr_words < num_to_win:
		_summon_word()
	else:
		_end_self_talk()

func _on_game_tutorial_finished_tutorial() -> void:
	if num_to_win == -1:
		num_to_win = 10000
	
	while curr_words < num_words_on_screen && curr_words < num_to_win:
		_summon_word()
