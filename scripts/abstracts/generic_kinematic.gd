extends KinematicBody2D

const col_math = preload("res://scripts/col_math.gd")

#these functions are used to generate or masks for the 
#collision layer and collision mask

#think of them as saying "all of this class is on layer and collides with"
#if there are exceptions to this rule they need to be added in inherited code 
func gen_col_layer()->int:
	return 0
func gen_col_mask()->int:
	return col_math.ConstLayer.TILE_BORDER #all entities collide with the border tile
#this is the function that actually sets the collision layer and mask values for
#our script
func load_collision():
	#all kinematics or their masks
	collision_layer |= gen_col_layer()
	collision_mask |= gen_col_mask()
func _ready():
	load_collision()
