extends Node2D

@onready var h_slider_mus_vol: HSlider = %HSlider_main_vol
@onready var h_slider_main_vol: HSlider = %HSlider_mus_vol
@onready var h_slider_sfx_vol: HSlider = %HSlider_sfx_vol
@onready var mus_vol_level: RichTextLabel = %MusVolLevel
@onready var vol_level: RichTextLabel = %VolLevel
@onready var sfx_vol_level: RichTextLabel = %SFXVolLevel
@onready var quit_button: Button = %QuitButton
@onready var exit_button: TextureButton = %ExitButton
@onready var page_flip_sound_effect: AudioStreamWAV = load("res://Audio/sound-effects/page-flip-2.wav")
@onready var scene: PackedScene = load("res://UI/Scenes/main_menu.tscn")

signal exit_pressed

var pg = 1
var vol = 100
var sfxvol = 100
var musvol = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_slider_sfx_vol.value = sfxvol
	h_slider_mus_vol.value = musvol
	h_slider_main_vol.value = vol
	vol_level.text = str(vol)
	mus_vol_level.text = str(musvol)
	sfx_vol_level.text = str(sfxvol)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_h_slider_main_vol_value_changed(value: float) -> void:
	vol = value
	GlobalAudio.set_master_vol(vol)
	vol_level.text = str(vol)


func _on_h_slider_sfx_vol_value_changed(value: float) -> void:
	sfxvol = value
	GlobalAudio.set_sfx_vol(sfxvol)
	sfx_vol_level.text = str(sfxvol)


func _on_h_slider_mus_vol_value_changed(value: float) -> void:
	musvol = value
	GlobalAudio.set_music_vol(musvol)
	mus_vol_level.text = str(musvol)


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()


func _on_exit_button_mouse_entered() -> void:
	exit_button.modulate.v = .8


func _on_exit_button_mouse_exited() -> void:
	exit_button.modulate.v = 1


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(scene)
