extends Object

#represents the time since the last combo object that this combo should fire
var delta = 0

#the errors represent the error time that the player is allowed

#posotive errro getter setters
var plus_err = .5 setget set_plus,get_plus
func get_plus():
	return plus_err

#make sure that the error is posotive
func set_plus(val):
	if (val < 0):
		val *= -1
	plus_err = val

#negetive error getter setters
var minus_err = .5 setget set_minus,get_minus
func get_minus():
	return minus_err
#make sure that the error is posotive
func set_minus(val):
	if (val < 0):
		val *= -1
	minus_err = val
	
#represents wether or not this input is supposed to be a falling ledge
var falling = true

#represents the action at this time
var action = ""

func find_match(cmbAct):
	return (
		cmbAct.falling == falling
	and cmbAct.action == action
	and plus_err + cmbAct.delta >= delta 
	and cmbAct.delta - minus_err <= delta
	)
