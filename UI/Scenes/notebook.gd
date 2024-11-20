extends Node2D

@onready var h_slider_mus_vol: HSlider = %HSlider_mus_vol
@onready var h_slider_sfx_vol: HSlider = %HSlider_sfx_vol
@onready var sfx_vol_level: RichTextLabel = %SFXVolLevel
@onready var mus_vol_level: RichTextLabel = %MusVolLevel
@onready var button_r: TextureButton = %ButtonR
@onready var button_l: TextureButton = %ButtonL
@onready var page_2: Control = %Page2
@onready var page_1: Control = %Page1
@onready var page_flip_sound_effect: AudioStreamWAV = load("res://Audio/sound-effects/page-flip-2.wav")
@onready var bgm: AudioStream = load("res://Audio/songs/wave/wave-theme.wav")

var pg = 1
var sfxvol = 100
var musvol = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.play_music(bgm)
	h_slider_sfx_vol.value = sfxvol
	h_slider_mus_vol.value = musvol
	mus_vol_level.text = str(musvol)
	sfx_vol_level.text = str(sfxvol)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match pg:
		1:
			page_1.visible = true
			page_2.visible = false
			button_l.modulate.a = 0
			button_l.disabled = true
			button_r.modulate.a = 1
			button_r.disabled = false
		2:
			page_1.visible = false
			page_2.visible = true
			button_l.modulate.a = 1
			button_l.disabled = false
			button_r.modulate.a = 0
			button_r.disabled = true

func _on_button_r_pressed():
	pg += 1
	GlobalAudio.play_sound(page_flip_sound_effect)

func _on_button_l_pressed():
	pg -= 1
	GlobalAudio.play_sound(page_flip_sound_effect)
	


func _on_h_slider_mus_vol_drag_ended(value_changed: bool) -> void:
	musvol = h_slider_mus_vol.value
	GlobalAudio.set_music_vol(musvol)
	mus_vol_level.text = str(musvol)

func _on_h_slider_sfx_vol_drag_ended(value_changed: bool) -> void:
	sfxvol = h_slider_sfx_vol.value
	GlobalAudio.set_sfx_vol(sfxvol)
	sfx_vol_level.text = str(sfxvol)
