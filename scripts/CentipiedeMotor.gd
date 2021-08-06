extends CentiRail

#this node functions as the end of the chain of centipide nodes
#it controls movement and sets the angle of the first node in the chain
var velocity : Vector2 = Vector2(0,100)

var pointRotationSpeed : float = 10
#pass the rotation speed back down the chain
func get_rotation_speed()->float:
	return pointRotationSpeed

func _ready():
	update_chain_angle_z(1.46)
func signum(x : float)->float:
	return -2*float(x < 0)+1
func get_velocity_angle()->float:
	return (-velocity).angle()
func _process(delta):
	position += velocity*delta
	print("[centipideMotor] target angle: " + str((-velocity).angle()))
	update_chain(get_velocity_angle(),delta)
