extends "res://scripts/SingingTree.gd"

func set_top_color(color):
	$TreeSprite/Node2D.modulate = color
func set_bottom_color(color):
	$TreeSprite/trunc.modulate = color
func _ready():
	set_bottom_color(Color.brown)
