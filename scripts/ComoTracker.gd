extends Node

var comboActionScript = load("res://scripts/comboAction.gd")
var comboContainerScript = load("res://scripts/combo_container.gd")

#used by callers to get the objects to interact with us
func get_combo_container():
	return comboContainerScript.new()
func get_combo_action():
	return comboActionScript.new()

#this signal gets fired when our node finds a combo
signal combo_found

#an array of combos to look for
var combos = []

#matches the given combo action with 
func match_combo(action_name,falling,delta):
	for container in combos:
			#check wether the action works with the given combo
			if(container.check_action(action_name,falling,time)):
				#print('['+container.name+'] match!')
				emit_signal("combo_found",container.name)
				
				#uncomment this line to increase efficiency when checking combos
				#but remove the abilty to make larger combos containing smaller combos
				
				#break
var time = 0
#this function feeds every input to the match_combo
func check_inputs(delta):
	time += delta
	for action in InputMap.get_actions():
		if (Input.is_action_just_pressed(action)):
			match_combo(action,false,delta)
		elif (Input.is_action_just_released(action)):
			match_combo(action,true,delta)
