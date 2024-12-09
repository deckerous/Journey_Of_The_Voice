extends Node2D
@onready var pause_button: TextureButton = %PauseButton
@onready var notebook_button: TextureButton = %NotebookButton
@onready var archive_button: TextureButton = %ArchiveButton
@onready var pause_menu: PackedScene
@onready var notebook_wrapper: Control = %Notebook_Wrapper
@onready var buttons_container: VBoxContainer = $ButtonsContainer
@onready var settings_wrapper: Control = %Settings_Wrapper
@onready var archive_wrapper: Control = %Archive_Wrapper

signal menu_entered
signal menu_exited
const UI_BLOOP_SELECT = preload("res://Audio/sound-effects/ui-bloop-select.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide menus to start
	notebook_wrapper.visible = false
	settings_wrapper.visible = false
	archive_wrapper.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_notebook_button_pressed() -> void:
	# Play the UI bloop select sound
	GlobalAudio.play_sound_id(UI_BLOOP_SELECT, "bloop-select", GlobalAudio.Bus.SFX, 1.0)
	# Show the notebook
	notebook_wrapper.visible = true
	buttons_container.visible = false
	menu_entered.emit()
	# get_tree().paused = true


func _on_notebook_exit_pressed() -> void:
	# Play the UI bloop select sound
	GlobalAudio.play_sound_id(UI_BLOOP_SELECT, "bloop-select", GlobalAudio.Bus.SFX, 1.0)
	# Hide the notebook
	notebook_wrapper.visible = false
	buttons_container.visible = true
	menu_exited.emit()
	# get_tree().paused = false


func _on_notebook_button_mouse_entered() -> void:
	# Hover effect on
	notebook_button.modulate.v = .8


func _on_notebook_button_mouse_exited() -> void:
	# Hover effect off
	notebook_button.modulate.v = 1


func _on_pause_button_pressed() -> void:
	# Play the UI bloop select sound
	GlobalAudio.play_sound_id(UI_BLOOP_SELECT, "bloop-select", GlobalAudio.Bus.SFX, 1.0)
	# Show settings page
	settings_wrapper.visible = true
	buttons_container.visible = false
	get_tree().paused = true


func _on_pause_button_mouse_entered() -> void:
	# Hover effect on
	pause_button.modulate.v = .8


func _on_pause_button_mouse_exited() -> void:
	# Hover effect off
	pause_button.modulate.v = 1


func _on_settings_exit_pressed() -> void:
	# Play the UI bloop select sound
	GlobalAudio.play_sound_id(UI_BLOOP_SELECT, "bloop-select", GlobalAudio.Bus.SFX, 1.0)
	# Hide settings menu
	settings_wrapper.visible = false
	buttons_container.visible = true
	get_tree().paused = false

func _on_archive_button_entered() -> void:
	archive_button.modulate.v = .8
	
func _on_archive_button_exited() -> void:
	archive_button.modulate.v = 1

func _on_archive_button_pressed() -> void:
	# Play the UI bloop select sound
	GlobalAudio.play_sound_id(UI_BLOOP_SELECT, "bloop-select", GlobalAudio.Bus.SFX, 1.0)
	# Show settings page
	ConversationArchive.visible(true)
	archive_wrapper.visible = true
	buttons_container.visible = false
	get_tree().paused = true
	
func _on_archive_exit_pressed() -> void:
	# Play the UI bloop select sound
	GlobalAudio.play_sound_id(UI_BLOOP_SELECT, "bloop-select", GlobalAudio.Bus.SFX, 1.0)
	ConversationArchive.visible(false)
	archive_wrapper.visible = false
	buttons_container.visible = true
	get_tree().paused = false
