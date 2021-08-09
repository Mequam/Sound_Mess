extends CircleRail

class_name CentiRail

#this class is designed to be a circle rail inteanded for the specific use
#case of mimicing centipide or snake like movement in a chain of children

func set_angle(angle : float)->void:
	#make sure that our value doesnt cascade to infinity
	.set_angle(fmod(angle,2*PI))
	#z_index = ceil((sin(angle))*4)
#ask up the chain to find our rotation speed
func get_rotation_speed()->float:
	return get_parent().get_rotation_speed()
#this function returns the angle that we would move with our rotation speed
func get_change(target_angle : float)-> float:
	var diff_angle = target_angle - angle
	var rotation_dir = sign(diff_angle)
	return rotation_dir*get_rotation_speed()*pow(diff_angle,2)/4
func update_chain_angle_z(angle : float):
	angle_z = angle
	if get_child(0) and get_child(0).has_method("update_chain_angle_z"):
		get_child(0).update_chain_angle_z(angle)

func update_chain(target_angle : float,delta : float) -> void:
	var change = get_change(target_angle)*delta
	set_angle(angle + change)
	if get_child(0) and get_child(0).has_method("update_chain"):
		get_child(0).update_chain(angle,delta)
