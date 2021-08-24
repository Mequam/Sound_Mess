extends CentiRail

class_name CentiMotor

#this node functions as the end of the chain of SECIFICALY centipide nodes
#it controls movement and sets the angle of the first node in the chain
#as well as contains variables that it feeds to and changes for all of the chain nodes bellow

#the direction that we are moving in
var velocity : Vector2 = Vector2(0,100) setget set_velocity,get_velocity
func set_velocity(val : Vector2):
	velocity = val
func get_velocity()->Vector2:
	return velocity

#how fast our chain links can rotate
var link_rotation_speed : float = 10
#used to pass the rotation speed back down the chain
func get_rotation_speed()->float:
	return link_rotation_speed

#the state of the animation chain
var link_anim_state : String = "Run" setget set_link_anim_state,get_link_anim_state
func set_link_anim_state(val : String)->void:
	link_anim_state = val
	if get_child(0) and get_child(0).has_method("set_anim_state"):
		get_child(0).anim_state = val
func get_link_anim_state()->String:
	return link_anim_state

#used to pass the state down to our chain links
func get_anim_state()->String:
	return get_link_anim_state()
	
func _ready():
	update_chain_angle_z(0.97)
func signum(x : float)->float:
	return -2*float(x < 0)+1
func get_velocity_angle()->float:
	return (-get_velocity()).angle()
func _process(delta):
	update_chain(get_velocity_angle(),delta)
