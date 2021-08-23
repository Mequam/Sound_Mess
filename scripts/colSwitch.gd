extends "res://scripts/abstracts/switch.gd"
#this is a switch that changes the collision of it's parent when
#the state of the switch changes

#default value is to be on no collision layer when the switch is on
#the idea here is that you "open a door" so to speek when the switch is hit
var col_mask_on : int = 0
#-1 is the default value, inteanded to be changed
var col_mask_off : int = -1

func set_on(val : bool):
	#call the parent setter
	.set_on(val)
	#set the parent collision layer
	get_parent().collision_mask = col_mask_on*int(on)+col_mask_off*int(not on)
func _ready():
	#if the off col mask is not set then we set it to the parent nodes collision mask 
	if (col_mask_off == -1 and get_parent()):
		col_mask_off = get_parent().collision_layer
