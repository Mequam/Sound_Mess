extends CentiMotor

#this is a very simple inherited class that uses the parents parent velocity instead of
#its own and is used for the tail of the centipide

#the other change is used for turning off the tail movement


#if this is false we do not update the chain
var do_chain_update : bool = true

func update_chain(target_angle : float,delta : float)->void:
	if do_chain_update:
		.update_chain(target_angle,delta)
func get_brain()->CentipideBoss:
	return get_parent().get_parent().get_child(0) as CentipideBoss

func set_velocity(val : Vector2):
	pass
func get_velocity()->Vector2:
	#gets the velocity of the boss script
	return get_brain().velocity
func get_rotation_speed()->float:
	return get_brain().movement_speed

func pass_player_entered(player : Player,segment : CentiBody)->void:
	get_brain().player_entered_tail(player,segment)
