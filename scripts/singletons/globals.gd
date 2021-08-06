extends Node
#this script is for generic gloabal code which needs to be accessible
#from all of the project.

#I will be a happy programmer if this script stays small

#this id represents the game save, when saving data
#we save it in the folder user://game{game_save_id}/blah
var game_save_id : int = 0

func get_scene_root()->Node:
	#this needs to be updated whenever we add a new global script
	return get_tree().get_root().get_child(2)

func get_scene_sub_beat()->float:
	#syntactic sugar for nodes to get the scene sub beat
	return get_scene_root().get_node("Met").get_node("Met").wait_time
