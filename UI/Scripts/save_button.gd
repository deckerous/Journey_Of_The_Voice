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
				var player = GlobalAudio.play_sound_id(music, "bar-theme", GlobalAudio.Bus.MUSIC)
				player.volume_db = -80
				GlobalAudio.tween_from_id("bar-theme", -15, 1.0) # TODO: change to global volume
