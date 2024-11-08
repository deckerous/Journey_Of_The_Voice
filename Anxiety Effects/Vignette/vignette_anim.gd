extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_scale = 1
	play("vignette_constriction")
	queue("vignette_idle")
	
