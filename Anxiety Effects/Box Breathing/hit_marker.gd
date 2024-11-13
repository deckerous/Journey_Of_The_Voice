extends Node2D

@onready var speed = 0.9

var num_successes = 0
var success_number = 4

signal success_number_reached

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide until button down
	visible = false
	$AnimationPlayer.speed_scale = speed
	$"../Button".buttonDown.connect(_on_buttonDown)
	$"../Button".buttonReleased.connect(_on_buttonRelease)

# Uses two arcs to create a hollow circle instead of a sprite for maximum pixels
func _draw() -> void:
	var point1 = Vector2(0, -14)
	var point2 = Vector2(0, 14)
	var angle1 = (point1 - point2).angle()
	var angle2 = (point2 - point1).angle()
	if angle2 < 0:
		angle2 += TAU
		
	draw_arc(Vector2(0, 0), 28, angle1, angle2, 100, Color.AQUA, 4)
	draw_arc(Vector2(0, 0), 28, angle1, angle2 - TAU, 100, Color.AQUA, 4)
	
# When button held down, start animation & make self visible
func _on_buttonDown() -> void:
	$"../RichTextLabel".text = "[center]Breathing intensifies[/center]"
	visible = true
	$"AnimationPlayer".queue("scale_down")
	
# When button released, check for success state & make self insivible
func _on_buttonRelease() -> void:
	if abs(scale.x - 1.0) < 0.3:
		# success state
		$"../RichTextLabel".text = "[center]Success![/center]"
		num_successes += 1
		if num_successes == success_number:
			success_number_reached.emit()
	else:
		# failure state
		$"../RichTextLabel".text = "[center]Failure[/center]"
	$"AnimationPlayer".play("disappear")
	
