extends Node2D
@onready var page_1: Control = $NotebookImgCont/Notebook/Page1
@onready var page_2: Control = $NotebookImgCont/Notebook/Page2
@onready var button_r: TextureButton = $ButtonR
@onready var button_l: TextureButton = $ButtonL
@onready var check_box_violence: CheckBox = $NotebookImgCont/Notebook/Page2/LeftPageCont/CheckBox_violence
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var vol_level_mus: RichTextLabel = %VolLevelMus
@onready var h_slider_vol_mus: HSlider = %HSlider_vol_mus
@onready var vol_level_sfx: RichTextLabel = %VolLevelSFX
@onready var h_slider_vol_sfx: HSlider = %HSlider_vol_sfx
@onready var page_turn_player: AudioStreamPlayer = $PageTurnPlayer


var pg = 1;
var vol_mus = 100;
var vol_sfx = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_slider_vol_mus.value = vol_mus
	h_slider_vol_sfx.value = vol_mus

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
	vol_level_mus.text = str(vol_mus,"%")
	vol_level_sfx.text = str(vol_sfx,"%")

func _on_button_r_pressed():
	pg += 1
	page_turn_player.play()
	
	

func _on_button_l_pressed():
	pg -= 1
	page_turn_player.play()

func _on_h_slider_vol_mus_drag_ended(value_changed: bool) -> void:
	vol_mus = h_slider_vol_mus.value
	var mus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(mus_idx, linear_to_db(vol_mus/100))



func _on_h_slider_vol_sfx_drag_ended(value_changed: bool) -> void:
	vol_sfx = h_slider_vol_sfx.value
	var sfx_idx = AudioServer.get_bus_index("SFX") 
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(vol_sfx/100))
