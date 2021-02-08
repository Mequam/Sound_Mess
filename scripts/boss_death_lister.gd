extends "res://scripts/abstracts/save_state_node.gd"
#this script contains the functions to save the death of a boss outside
#of 
func get_boss_name()-> String:
	#returns the name of the boss that this script saves for
	#this is inteanded to be overloaded
	return "default"
func get_save_path():
	return "user://game" + get_game_save_file() + "/statue/" + get_boss_name() + ".dat"
func save_boss_killed():
	#this function saves the death of the boss
	var data = .read_data_path(get_save_path())
	if data.has("just_killed"):
		data.just_killed += 1
