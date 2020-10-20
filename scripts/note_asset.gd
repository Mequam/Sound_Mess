extends Node2D
#this is a simple script that changes the direction the note base points
#to be intutive for the player to read

#the initial scale that we use for reference when changing direction
var init_scale : Vector2

#simple function to get our squished scale
func get_squished_scale(amount = Vector2(0.75,1.5)):
	return Vector2(init_scale.x*amount.x,init_scale.y*amount.y)
func rot_base(degree):
	$base.global_rotation_degrees = degree
#the musical degree of the scale which we represent
var display_degree : int setget set_degree,get_degree
func set_degree(val):
	if (val >= 1 and val <=6):
		$base.scale = get_squished_scale()
	else:
		$base.scale = init_scale
	match val:
		0:
			rot_base(0)
		1:
			#left
			rot_base(90)
		2:
			#down
			rot_base(0)
		3:
			#up
			rot_base(180)
		4:
			#right
			rot_base(-90)
		5:
			#special a
			rot_base(45)
		6:
			#special b
			rot_base(-45)
		7:
			rot_base(180)
	display_degree = val
func get_degree():
	return display_degree

func _ready():
	init_scale = $base.scale
