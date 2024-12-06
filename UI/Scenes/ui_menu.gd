extends Node2D
@onready var pause_button: TextureButton = %PauseButton
@onready var notebook_button: TextureButton = %NotebookButton
@onready var pause_menu: PackedScene
@onready var notebook_wrapper: Control = %Notebook_Wrapper
@onready var buttons_container: VBoxContainer = $ButtonsContainer
@onready var settings_wrapper: Control = %Settings_Wrapper


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
<<<<<<< HEAD
	# Hide menus to start
=======
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	notebook_wrapper.visible = false
	settings_wrapper.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_notebook_button_pressed() -> void:
<<<<<<< HEAD
	# Show the notebook
=======
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	notebook_wrapper.visible = true
	buttons_container.visible = false


func _on_notebook_exit_pressed() -> void:
<<<<<<< HEAD
	# Hide the notebook
=======
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	notebook_wrapper.visible = false
	buttons_container.visible = true


func _on_notebook_button_mouse_entered() -> void:
<<<<<<< HEAD
	# Hover effect on
=======
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	notebook_button.modulate.v = .8


func _on_notebook_button_mouse_exited() -> void:
<<<<<<< HEAD
	# Hover effect off
=======
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	notebook_button.modulate.v = 1


func _on_pause_button_pressed() -> void:
<<<<<<< HEAD
	# Show settings page
=======
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	settings_wrapper.visible = true
	buttons_container.visible = false


func _on_pause_button_mouse_entered() -> void:
<<<<<<< HEAD
	# Hover effect on
=======
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	pause_button.modulate.v = .8


func _on_pause_button_mouse_exited() -> void:
<<<<<<< HEAD
	# Hover effect off
	pause_button.modulate.v = 1


func _on_settings_exit_pressed() -> void:
	# Hide settings menu
=======
	notebook_button.modulate.v = 1


func _on_settings_exit_pressed() -> void:
>>>>>>> 0490ef9e1cef440dba266ed00b47d08b845173cb
	settings_wrapper.visible = false
	buttons_container.visible = true
