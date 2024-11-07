extends Node2D

@onready var isPressed = false

signal buttonDown
signal buttonReleased

func _draw() -> void:
	draw_circle(Vector2(0, 0), 32, Color.BLACK)
	draw_circle(Vector2(0, 0), 24, Color.WHITE)


func interactable_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			isPressed = true
			buttonDown.emit()
		if event.is_action_released("click"):
			isPressed = false
			buttonReleased.emit()
		print(isPressed)


func _on_interactable_mouse_exited() -> void:
	if isPressed:
		buttonReleased.emit()
	isPressed = false
	print(isPressed)
