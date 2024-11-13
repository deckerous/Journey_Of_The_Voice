extends Node

@onready var anim_player = $AnimationPlayer

func show():
	anim_player.play("fade_in")
	await anim_player.animation_finished
	
func disappear():
	anim_player.play("fade_out")
	await anim_player.animation_finished
