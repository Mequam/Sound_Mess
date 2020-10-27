extends Object

#represents the time since the last combo object that this combo should fire
var delta = 0

#the errors represent the error time that the player is allowed

#wrapper to set error to fractional values of delta
var err_perc setget set_err_perc,get_err_perc
func set_err_perc(val):
	err = delta/val
func get_err_perc():
	pass
#negetive error getter setters
var err = .5 setget set_err,get_err
func get_err():
	return err
#make sure that the error is posotive
func set_err(val):
	if (val < 0):
		val *= -1
	err = val
#represents wether or not this input is supposed to be a falling ledge
var falling = true

#represents the action at this time
var action = ""
func toStr():
	return 	action + " " +str(falling)+ " @" + str(delta)
func find_match(cmbAct):
	return (
	cmbAct.falling == falling
	and cmbAct.action == action
	and err + cmbAct.delta >= delta 
	and cmbAct.delta - err <= delta
	)
