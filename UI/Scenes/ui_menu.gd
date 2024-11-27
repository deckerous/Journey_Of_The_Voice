extends Node2D
@onready var pause_button: TextureButton = %PauseButton
@onready var notebook_button: TextureButton = %NotebookButton
@onready var pause_menu: PackedScene
@onready var notebook_wrapper: Control = %Notebook_Wrapper
@onready var buttons_container: VBoxContainer = $ButtonsContainer
@onready var settings_wrapper: Control = %Settings_Wrapper


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notebook_wrapper.visible = false
	settings_wrapper.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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


func _on_pause_button_pressed() -> void:
	settings_wrapper.visible = true
	buttons_container.visible = false


func _on_pause_button_mouse_entered() -> void:
	pause_button.modulate.v = .8


func _on_pause_button_mouse_exited() -> void:
	notebook_button.modulate.v = 1


func _on_settings_exit_pressed() -> void:
	settings_wrapper.visible = false
	buttons_container.visible = true
