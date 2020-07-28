extends Node2D

var leg_color setget set_leg_color,get_leg_color
func get_leg_color():
	return $spdier/legs/frb.modulate
func set_leg_color(color):
	$spdier/legs/frb.modulate = color
	$spdier/legs/flb.modulate = color
	$spdier/legs/brb.modulate = color
	$spdier/legs/blb.modulate = color
func _ready():
	pass
