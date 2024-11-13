extends Node2D
@onready var page_1: Node2D = %page_1
@onready var page_2: Node2D = %page_2
@onready var tutorial_button: Button = %TutorialButton

var pg = 1
@export var game_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page_1.visible = true
	page_2.visible = false
	tutorial_button.text = "Next Page" 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tutorial_button_pressed() -> void:
	if pg == 1:
		pg = 2
		page_1.visible = false
		page_2.visible = true
		tutorial_button.text = "Try Game" 
	if pg == 2:
		var tutorial = game_scene.instantiate()
		add_child(tutorial)
