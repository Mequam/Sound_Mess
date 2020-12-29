extends Node

#this script is global data that is used to load new scenes
#in our door system

#think of it like a safe box to store data in before destroying
#and re-building a house

var load_able_player_position = null
var prev_door_name = null
var prev_scene = null





func load_scene(scene,prevScene,prevDoorName=null,loadablePlayerPos=null):
	#store the information about the prevoius scene and
	#the door that the player is coming from
	prev_scene = prevScene
	load_able_player_position = loadablePlayerPos
	prev_door_name = prevDoorName
	#actually load the scene
	get_tree().change_scene(scene)
