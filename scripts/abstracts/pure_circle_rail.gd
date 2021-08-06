extends Node2D

#this node contains the math required to move a circle rail in the
#pure sense, without any state involved
#it is inteanded to be inherited by a child that utilizes state 

func get_pos_perspective(angle : float,angle_z : float,r : float,center : Vector2 = Vector2(0,0)) -> Vector2:
	return Vector2(cos(angle),cos(angle_z)*sin(angle))*r+center
#gets the scale of a sphear at the given rotations
func get_scaled_perspective(angle : float,
							angle_z : float,
							cam_dist : float,
							focus_offset : float,
							r : float)->float:
	#sin is negative here because of game chords bieng inverted
	return cam_dist/(focus_offset-sin(angle)*sin(angle_z)*r)
#retrive the derivative of a point on the squashed circle drawn on the screen
func get_rotational_derivative(angle : float,angle_z : float) -> Vector2:
	return Vector2(-sin(angle),cos(angle)*cos(angle_z))
