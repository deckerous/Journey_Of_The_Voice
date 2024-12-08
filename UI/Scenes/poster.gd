extends Node2D

@onready var poster_button: TextureButton = $PosterButton
@onready var background: ColorRect = $CanvasLayer/Background
@onready var poster: HBoxContainer = $CanvasLayer/Poster
@onready var back_button: TextureButton = $CanvasLayer/BackButton
@onready var animation_player: AnimationPlayer = $CanvasLayer/PosterButton/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.hide()
	poster.hide()
	back_button.hide()
	animation_player.play("modulate")

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

func _on_poster_button_mouse_entered() -> void:
	pass # Replace with function body.
