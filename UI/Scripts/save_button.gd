extends ColorRect

@export var chapter_scene: PackedScene

@onready var music: AudioStreamWAV = load("res://Audio/songs/bar/bar-theme.wav")

func _ready() -> void:
	self.gui_input.connect(on_dialogue_click)

func on_dialogue_click(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			if chapter_scene is PackedScene:
				GlobalAudio.get_child(0).queue_free()
				get_tree().paused = true
				await Transition.show()
				get_tree().paused = false
				get_tree().change_scene_to_packed(chapter_scene)
				Transition.disappear()
				var stream = GlobalAudio.play_sound(music)
				stream.volume_db = -15
