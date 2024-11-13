extends Node2D

@onready var h_slider_mus_vol: HSlider = %HSlider_mus_vol
@onready var h_slider_sfx_vol: HSlider = %HSlider_sfx_vol
@onready var sfx_vol_level: RichTextLabel = %SFXVolLevel
@onready var mus_vol_level: RichTextLabel = %MusVolLevel
@onready var button_r: TextureButton = %ButtonR
@onready var button_l: TextureButton = %ButtonL
@onready var page_2: Control = %Page2
@onready var page_1: Control = %Page1
@onready var page_flip_sound_effect: AudioStreamPlayer = %PageFlipSoundEffect


@onready var bgm: AudioStream = load("res://Audio/songs/wave/wave-theme.wav")

var pg = 1;
var vol = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudio.play_sound(bgm)
	h_slider_vol.value = vol

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match pg:
		1:
			page_1.visible = true
			page_2.visible = false
			button_l.visible = false
			button_r.visible = true
		2:
			page_1.visible = false
			page_2.visible = true
			button_l.visible = true
			button_r.visible = false
	vol_level.text = str(vol,"%")

func _on_button_r_pressed():
	pg += 1
	

func _on_button_l_pressed():
	pg -= 1
	

func _on_h_slider_vol_drag_ended(_value_changed: bool) -> void:
	vol = h_slider_vol.value
	GlobalAudio.set_global_vol(vol)
