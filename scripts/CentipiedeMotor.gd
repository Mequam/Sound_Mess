extends CentiRail

class_name CentiMotor

#this node functions as the end of the chain of SPECIFICALY centipide nodes
#it controls movement and sets the angle of the first node in the chain
#as well as contains variables that it feeds to and changes for all of the chain nodes bellow

#the direction that we are moving in
var velocity : Vector2 = Vector2(0,100)

#the speed we move
var movement_speed : float = 1

#how fast our chain links can rotate
var link_rotation_speed : float = 10
#used to pass the rotation speed back down the chain
func get_rotation_speed()->float:
	return link_rotation_speed

#the state of the animation chain
var link_anim_state : String = "Run"
#used to pass the state down to our chain links
func get_anim_state()->String:
	return link_anim_state
	
func _ready():
	update_chain_angle_z(1.46)
func signum(x : float)->float:
	return -2*float(x < 0)+1
func get_velocity_angle()->float:
	return (-velocity).angle()
func _process(delta):
	position += velocity*delta*movement_speed
	print("[centimotor:filter] velocity angle " + str(get_velocity_angle()))
	update_chain(get_velocity_angle(),delta)
