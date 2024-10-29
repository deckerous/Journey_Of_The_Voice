extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_scale = 0.5
	play("vignette_constriction_1")
