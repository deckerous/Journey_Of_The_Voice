class_name Chapter
extends Node

@export var next_chapter: PackedScene
@export var starting_area: Area

var main_objective_complete = false

func _ready():
	var children = get_children()
	for child in children:
		child.background.visible = false
