extends "res://scripts/SingingTree.gd"

func set_top_color(color):
	$TreeSprite/leafs.modulate = color
func set_bottom_color(color):
	$TreeSprite/trunk.modulate = color
func get_top_color():
	return $TreeSprite/leafs.modulate 
func _ready():
	set_bottom_color(Color.brown)
