extends Node2D
@onready var pause_button: TextureButton = %PauseButton
@onready var notebook_button: TextureButton = %NotebookButton
@onready var pause_menu: PackedScene
@onready var notebook_wrapper: Control = %Notebook_Wrapper
@onready var buttons_container: VBoxContainer = $ButtonsContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notebook_wrapper.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_notebook_button_pressed() -> void:
	notebook_wrapper.visible = true
	buttons_container.visible = false


func _on_notebook_exit_pressed() -> void:
	notebook_wrapper.visible = false
	buttons_container.visible = true


func _on_notebook_button_mouse_entered() -> void:
	notebook_button.modulate.v = .8


func _on_notebook_button_mouse_exited() -> void:
	notebook_button.modulate.v = 1
