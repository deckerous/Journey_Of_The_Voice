extends Node2D
@onready var h_slider_mus_vol: HSlider = %HSlider_mus_vol
@onready var h_slider_sfx_vol: HSlider = %HSlider_sfx_vol
@onready var check_box_violence: CheckBox = $NotebookImgCont/Notebook/Page2/LeftPageCont/CheckBox_violence
@onready var sfx_vol_level: RichTextLabel = %SFXVolLevel
@onready var mus_vol_level: RichTextLabel = %MusVolLevel
@onready var button_r: TextureButton = %ButtonR
@onready var button_l: TextureButton = %ButtonL
@onready var page_2: Control = %Page2
@onready var page_1: Control = %Page1
@onready var page_flip_sound_effect: AudioStreamPlayer = %PageFlipSoundEffect


var pg = 1;
var sfxvol = 100;
var musvol = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_slider_mus_vol.value = musvol
	h_slider_sfx_vol.value = sfxvol

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
	sfx_vol_level.text = str(sfxvol,"%")
	mus_vol_level.text = str(musvol,"%")

func _on_button_r_pressed():
	pg += 1
	page_flip_sound_effect.play()
	
	

func _on_button_l_pressed():
	pg -= 1
	page_flip_sound_effect.play()
	

func _on_h_slider_sfx_vol_drag_ended(_value_changed: bool) -> void:
	sfxvol = h_slider_sfx_vol.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfxvol*.01))


func _on_h_slider_mus_vol_drag_ended(value_changed: bool) -> void:
	musvol = h_slider_mus_vol.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(musvol*.01))
