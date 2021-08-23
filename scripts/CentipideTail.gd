extends CentiMotor

#this is a very simple inherited class that uses the parents parent velocity instead of
#its own

func set_velocity(val : Vector2):
	pass
func get_velocity()->Vector2:
	return get_parent().get_parent().velocity
func get_rotation_speed()->float:
	return get_parent().get_parent().movement_speed/10
