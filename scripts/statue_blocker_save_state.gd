extends "res://scripts/abstracts/save_state_node.gd"
#this script contains the functions to load the state of
#statues which block progression paths upon boss death

#they are primaraly inteanded for reading the state as apposed to
#writing it

func get_save_path() -> String:
	return "user://game" + .get_game_save_file() + "/statue/" + get_parent().name + ".dat"
func serialize() -> Dictionary:
	return {"anim_killed" : get_parent().anim_killed}
#unique save state function that returns the nubmer of bosses that the player has
#killed according to the boss array of the parent
func get_boss_kill_count(bosses)->int: #bosses should be a string array
	var ret_val : int = 0
	for boss_path in bosses:
		var dataDict : Dictionary = read_data_path("user://game" + .get_game_save_file() + "/" + boss_path + ".dat")
		if dataDict.has("mode") and dataDict.mode and dataDict.mode == "dead":
			ret_val += 1
	return ret_val
