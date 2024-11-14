extends Node2D

@onready var hit_marker = $"Hit Marker"
@onready var bb_animation_player = $BBAnimationPlayer

signal box_breathing_complete
signal box_breathing_started

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bb_animation_player.play("fade_in")
	GlobalAudio.get_child(0).volume_db = -65
	
	# Position button in screen center
	var centerX = get_viewport_rect().size.x / 2
	var centerY = get_viewport_rect().size.y / 2
	
	position = Vector2(centerX, centerY)
	
	hit_marker.success_number_reached.connect(end_box_breathing)

func end_box_breathing():
	self.box_breathing_complete.emit()
	bb_animation_player.play("fade_out")
	await bb_animation_player.animation_finished
	GlobalAudio.get_child(0).volume_db = -15
	self.queue_free()
