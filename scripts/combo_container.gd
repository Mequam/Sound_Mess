extends Object
signal score_changed

#this object represents a combo containing comboActions
var comboActionScript = load("res://scripts/comboAction.gd")
#the name of the combo
var name = ""
#the actions of the combo, sorted based on the times that they occure
var action_list = []
#the score of the combo, used to keep track of how many actions the player has hit
var score = 0 setget set_score,get_score
#setter function for score allows for hooks when it changes
func set_score(val):
	var old_score = score
	score = val
	
	#make sure that any who care know if our score changes
	if val != old_score:
		emit_signal("score_changed",val)
func get_score():
	return score 

#this is a syntatic sugar function to create combo actions
func newComboAction(act="",fall=false,delta=5):
	var retVal = comboActionScript.new()
	retVal.action = act
	retVal.falling = fall
	retVal.delta = delta
	return retVal
func addNewComboAction(act="",fall=false,delta=5,perc_err=4):
	var cmbAct = newComboAction(act,fall,delta)
	cmbAct.err_perc = perc_err
	action_list.append(cmbAct)
var last_time = 0

#checks wether the given combo action is inside of our combo for our score
func check_action(action_name,falling,time):
	#make a combo action with the required delta time
	var cmbAct = comboActionScript.new()
	cmbAct.action = action_name
	cmbAct.falling = falling
	if (score == 0):
		cmbAct.delta = 0
	else:
		cmbAct.delta = time-last_time
	#check that combo action for a match
	if (score < len(action_list) and action_list[score].find_match(cmbAct)):
		#we found a  match
		set_score(score + 1)
		if (score == len(action_list)):
			#reset the score so we can look again
			set_score(0)
			#return true because we found a match
			return true
		last_time = time
	else:
		#we did not find a match, reset the score to start looking from the begining again
		set_score(0)
	#we did not return when we found a match, return false
	return false
