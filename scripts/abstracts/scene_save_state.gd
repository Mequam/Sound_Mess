extends "res://scripts/abstracts/save_state_node.gd"
#this node functions as a scene save state node for
#main scenes

#think of it as a convinent way to add state independent 
#of loading to a scene

func get_save_path()-> String:
	return "user://game" + .get_game_save_file() + "/"+ get_parent().name + ".dat"
