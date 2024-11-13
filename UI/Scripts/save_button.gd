extends ColorRect

@export var chapter_scene: PackedScene

func _ready() -> void:
	self.gui_input.connect(on_dialogue_click)

func on_dialogue_click(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			if chapter_scene is PackedScene:
				get_tree().paused = true
				await Transition.show()
				get_tree().paused = false
				get_tree().change_scene_to_packed(chapter_scene)
				Transition.disappear()
