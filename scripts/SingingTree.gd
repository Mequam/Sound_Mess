extends "res://scripts/abstracts/generic_static.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("plants")
	add_to_group("singing_trees")
func on_col(player,dmg):
	if ($JuteBox.singing):
		$JuteBox.stop()
	$JuteBox.singing = !$JuteBox.singing

var top_color setget set_top_color,get_top_color
func set_top_color(color):
	pass
func get_top_color():
	return top_color

var bottom_color setget set_bottom_color,get_bottom_color
func set_bottom_color(color):
	pass
func get_bottom_color():
	return bottom_color
