extends CentiMotor

#this is a very simple inherited class that uses the parents parent velocity instead of
#its own and is used for the tail of the centipide

#the other change is used for turning off the tail movement


#if this is false we do not update the chain
var do_chain_update : bool = true

func update_chain(target_angle : float,delta : float)->void:
	if do_chain_update:
		.update_chain(target_angle,delta)
func set_velocity(val : Vector2):
	pass
func get_velocity()->Vector2:
	return get_parent().get_parent().velocity
func get_rotation_speed()->float:
	return get_parent().get_parent().movement_speed/10
