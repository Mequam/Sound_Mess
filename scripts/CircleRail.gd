extends "res://scripts/abstracts/pure_circle_rail.gd"

class_name CircleRail

#this node controls the rotational movement
#that will be used by the centipide enemy

#you can think of this node as the "pure"
#haskell like implimentation of the idea
#of a rotating node, it is inteaended to be
#overidden with update functions and state 

#TODO: this would be a good canidit for 
#a C++ godot module for the sin cosin behavior

#offset from node parent
var center : Vector2 = Vector2(0,0) setget set_center,get_center
func set_center(val : Vector2):
	center = val
	sync_state()
func get_center()->Vector2:
	return center
	
	
#radius of our circle
var r : float = 100 setget set_r,get_r
func set_r(val : float)->void:
	r = val
	sync_state()
func get_r() -> float:
	return r
	
#the 3d rotation angle of our path
#posotive values rotate the top of a circle away
var angle_z : float = 0 setget set_angle_z,get_angle_z
func set_angle_z(val : float)->void:
	angle_z = val
	sync_state()
func get_angle_z()->float:
	return angle_z

#angle along the circle that we are located
var angle : float = PI/2 setget set_angle,get_angle
func set_angle(val : float)->void:
	angle = val
	sync_state()
func get_angle()->float:
	return angle

#distance beetween the camera and the point of focus
var cam_dist : float = 400 setget set_cam_dist,get_cam_dist
func set_cam_dist(val : float)->void:
	cam_dist = val
	sync_state()
func get_cam_dist()->float:
	return cam_dist

#how far from z=0 the focus point is, imagine it 
#stabbing you in the face from the computer screen 
var focus_offset : float = 500 setget set_focus_offset,get_focus_offset
func set_focus_offset(val : float)->void:
	focus_offset = val
	sync_state()
func get_focus_offset()->float:
	return focus_offset
#updates the position and scale values of our node
func update_state(angle : float,angle_z : float,
				cam_dist : float,focus_offset : float,
				r : float,center : Vector2 = Vector2(0,0))->void:
	position = get_pos_perspective(angle,angle_z,r,center)
	scale = Vector2(1,1)*get_scaled_perspective(angle,angle_z,
												cam_dist,focus_offset,r)
#has the child node state updated
func update_child_state(angle : float,angle_z : float,
				cam_dist : float,focus_offset : float,
				r : float,center : Vector2 = Vector2(0,0))->void:
	if (get_child(0) is Node2D):
		print("updating child state")
		get_child(0).position = get_pos_perspective(angle,angle_z,r,center)
		get_child(0).scale = Vector2(1,1)*get_scaled_perspective(angle,angle_z,
												cam_dist,focus_offset,r)
#syntactic sugar to sync with our state
func sync_state()->void:
	update_child_state(angle,angle_z,cam_dist,focus_offset,r,center)
