extends Node2D

@onready var poster_button: TextureButton = $CanvasLayer/PosterButton
@onready var background: ColorRect = $CanvasLayer/Background
@onready var poster: HBoxContainer = $CanvasLayer/Poster
@onready var back_button: TextureButton = $CanvasLayer/BackButton
@onready var animation_player: AnimationPlayer = $CanvasLayer/PosterButton/AnimationPlayer

signal now_visible
signal now_invisible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable_button()
	background.hide()
	poster.hide()
	back_button.hide()

func _on_poster_button_pressed() -> void:
	background.show()
	poster.show()
	back_button.show()
	now_visible.emit()

func _on_back_button_pressed() -> void:
	background.hide()
	poster.hide()
	back_button.hide()
	now_invisible.emit()

func disable_button():
	animation_player.play("RESET")
	poster_button.disabled = true
	poster_button.mouse_default_cursor_shape = Control.CURSOR_ARROW

func enable_button():
	animation_player.play("modulate")
	poster_button.disabled = false
	poster_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
