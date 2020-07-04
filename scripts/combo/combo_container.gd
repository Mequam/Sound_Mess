extends Object
#this object represents a combo containing comboActions
var comboActionScript = load("res://scripts/combo/comboAction.gd")
#the name of the combo
var name = ""
#the actions of the combo, sorted based on the times that they occure
var action_list = []
#the score of the combo, used to keep track of how many actions the player has hit
var score = 0
#represents the offset in time that we use to get delta
var first_action_time = 0
#checks wether the given combo action is inside of our combo for our score
func check_action(action_name,falling,time):
	
	#if this is the first action that we see we need to store its time to check the next actions
	if (score == 0):
		first_action_time = time

	#make a comboaction with the required delta time
	var cmbAct = comboActionScript.new()
	cmbAct.action = action_name
	cmbAct.falling = falling
	cmbAct.delta = time-first_action_time
	
	#print(cmbAct.action + " " +str(cmbAct.falling)+ " @" + str(cmbAct.delta))
	#check that combo action for a match
	if (score < len(action_list) and action_list[score].find_match(cmbAct)):
		#we found a  match
		score += 1
		if (score == len(action_list)):
			#use a new base time for our next checks
			first_action_time = time
			#reset the score so we can look again
			score = 0
			#return true because we found a match
			return true
	else:
		#we did not find a match, reset the score to start looking from the begining again
		score = 0
		
	#we did not return when we found a match, return false
	return false
