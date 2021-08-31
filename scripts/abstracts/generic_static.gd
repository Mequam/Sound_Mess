extends StaticBody2D

class_name GenericStatic

#this is a simple script that all static bodies are inteanded
#to inherit from in order to utilize the collision math and keep all
#collision enumerators on the same page

var col_math = preload("res://scripts/col_math.gd")

#these functions are used to generate or masks for the 
#collision layer and collision mask

#think of them as saying "all of this class is on layer and collides with"
#if there are exceptions to this rule they need to be added in inherited code 
func gen_col_layer()->int:
	return col_math.Layer.TERRAIN #we are on the terrain layer
func gen_col_mask()->int:
	return 0 #static bodies do not usually collide with anything

func _ready():
	collision_layer |= gen_col_layer()
	collision_mask |= gen_col_mask()
