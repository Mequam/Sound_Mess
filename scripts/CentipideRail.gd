extends CircleRail

class_name CentiRail

#this class is designed to be a circle rail inteanded for the specific use
#case of mimicing centipide or snake like movement in a chain of children


#this function is a wraper for godots fmod function that gives it the behavior
#desired for this application of fmod namely repeating y=x with a period ranging -pi to pi over the x axis

#base_over_2 is used because it is faster to compute x*2 than x/2
func mod_float(inp : float,base_over_2 : float)->float:
	return sign(inp-base_over_2)*(abs(fmod(inp-base_over_2,base_over_2*2))-base_over_2)

#wrapper to set the angle
func set_angle(angle : float)->void:
	#make sure that our value doesnt cascade to infinity
	.set_angle(mod_float(angle,PI))
	#z_index = ceil((sin(angle))*4)

#ask up the chain to find our rotation speed
func get_rotation_speed()->float:
	return get_parent().get_rotation_speed()

#this function returns the angle that we would move with our rotation speed
func get_change(target_angle : float)-> float:
	var diff_angle = target_angle - angle
	var rotation_dir = sign(diff_angle) if abs(diff_angle) < PI else -sign(diff_angle)
																		#make sure that if we end up adding a negative value to 2PI we do not go out of range
	var rotation_speed = pow(diff_angle,2) if abs(diff_angle) < PI else pow(mod_float(2*PI-diff_angle,PI),2)	
	
	return rotation_dir*get_rotation_speed()*rotation_speed/40
func update_chain_angle_z(angle : float):
	angle_z = angle
	if get_child(0) and get_child(0).has_method("update_chain_angle_z"):
		get_child(0).update_chain_angle_z(angle)
func update_chain(target_angle : float,delta : float) -> void:
	var change = get_change(target_angle)*delta
	set_angle(angle + change)
	if get_child_count() > 0 and get_child(0).has_method("update_chain"):
		get_child(0).update_chain(angle,delta)

#this function returns the last node in the chain of nodes
#think of it like asking each node bellow the chain if it is the last one there
func get_last_link()->Node2D:
	if get_child_count() > 0 and get_child(0).has_method("get_last_link"):
		return get_child(0).get_last_link()
	return self
func get_link_list(inp_arr : Array=[])->Array:
	#get ourselfs appended to the chain
	inp_arr.append(self)
	#if we have a child
	if get_child_count() > 0 and get_child(0).has_method("get_last_link"):
		#get the child to append itself to the chain
		return get_child(0).get_link_list(inp_arr)
	#we have no children, so return the array
	return inp_arr
