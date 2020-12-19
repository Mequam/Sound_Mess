extends "res://scripts/SingingTree.gd"

func set_top_color(color):
	$JuteBox/Sprite/Node2D.modulate = color
func set_bottom_color(color):
	$JuteBox/Sprite/trunc.modulate = color
func _ready():
	set_bottom_color(Color.brown)
