extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$"../Button".buttonDown.connect(_on_buttonDown)
	$"../Button".buttonReleased.connect(_on_buttonRelease)

func _draw() -> void:
	var point1 = Vector2(0, -14)
	var point2 = Vector2(0, 14)
	var angle1 = (point1 - point2).angle()
	var angle2 = (point2 - point1).angle()
	if angle2 < 0:
		angle2 += TAU
		
	draw_arc(Vector2(0, 0), 28, angle1, angle2, 100, Color.AQUA, 4)
	draw_arc(Vector2(0, 0), 28, angle1, angle2 - TAU, 100, Color.AQUA, 4)
	
func _on_buttonDown() -> void:
	$"../RichTextLabel".text = "breathing intensifies"
	visible = true
	$"./AnimationPlayer".queue("scale_down")
	
func _on_buttonRelease() -> void:
	if abs(scale.x - 1.0) < 0.3:
		# success state
		$"../RichTextLabel".text = "Success!"
	else:
		# failure state
		$"../RichTextLabel".text = "Failure"
	$"./AnimationPlayer".stop()
	$"./AnimationPlayer".queue("RESET")
