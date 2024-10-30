extends Node2D
@onready var page_1: Control = $NotebookImgCont/Notebook/Page1
@onready var page_2: Control = $NotebookImgCont/Notebook/Page2
@onready var button_r: TextureButton = $ButtonR
@onready var button_l: TextureButton = $ButtonL
@onready var h_slider_vol: HSlider = $NotebookImgCont/Notebook/Page2/LeftPageCont/HSlider_vol
@onready var check_box_violence: CheckBox = $NotebookImgCont/Notebook/Page2/LeftPageCont/CheckBox_violence
@onready var vol_level: RichTextLabel = $NotebookImgCont/Notebook/Page2/LeftPageCont/HBoxContainer2/VolLevel


var pg = 1;
var vol = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_slider_vol.value = vol

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	

func _on_h_slider_vol_drag_ended(value_changed: bool) -> void:
	vol = h_slider_vol.value
