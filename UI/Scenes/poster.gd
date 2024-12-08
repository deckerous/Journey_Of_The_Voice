extends Node2D

@onready var poster_button: TextureButton = $CanvasLayer/PosterButton
@onready var background: ColorRect = $CanvasLayer/Background
@onready var poster: HBoxContainer = $CanvasLayer/Poster
@onready var back_button: TextureButton = $CanvasLayer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.hide()
	poster.hide()
	back_button.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_poster_button_pressed() -> void:
	background.show()
	poster.show()
	back_button.show()

func _on_back_button_pressed() -> void:
	background.hide()
	poster.hide()
	back_button.hide()
