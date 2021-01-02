extends Node

#this script is global data that is used to load new scenes
#in our door system

#think of it like a safe box to store data in before destroying
#and re-building a house

var load_able_player_position = null
var prev_door_name = null
var prev_scene = null
#this stores a reference to the player and we use it to load and unload the player
#use the setters and getters to limit access to the player reference
var _player_ref : Node setget set_player_ref, get_player_ref
func set_player_ref(val):
	print("[WARNING] node attempting to set global player ref")
func get_player_ref():
	print("[WARNING] node attempting to get global player ref")




func load_scene(scene,prevScene,prevDoorName=null,loadablePlayerPos=null):
	#store the information about the prevoius scene and
	#the door that the player is coming from
	prev_scene = prevScene
	load_able_player_position = loadablePlayerPos
	prev_door_name = prevDoorName

	var root = get_tree().root
	var oldScene = root.get_child(2)
	
	#orphan the player so they are no longer in the scene
	oldScene.call_deferred("remove_child",_player_ref)
	
	#remove the previous scene
	oldScene.call_deferred("free")
	
	#prepare and load the new scene by adding the player
	var toLoad : Node = load(scene).instance()
	toLoad.call_deferred("add_child",_player_ref)
	
	print("[loading] " + toLoad.name)
	#actually load the new scene
	root.call_deferred("add_child",toLoad)

	print("[Finished] :D ")
#loads the player from the disc into global memory
#so the players state never changes
func load_player():
	_player_ref = load("res://scenes/instance/entities/player.tscn").instance()

#this function starts the given game save file and
#loads the last scene that the player saved at
func load_game(idx : int):
	Globals.game_save_id = idx
	#we use the code in the save state node to pull the state that we need
	#noramaly the save state node operates on its parent, but we pupaterit here
	#in order to use its functions to load without using parent operations as we are a script without
	#a larger scene
	var saveStateNode = load("res://scripts/abstracts/save_state_node.gd").new()
	#last scene contains the path to the scene that we load, if it does not exist,
	#the player is starting for the first time
	var pathDict : Dictionary = saveStateNode.read_data_path("user://game" + str(idx) + "/last_scene.dat")
	if pathDict.has("path"):
		#load the stored path
		load_scene(pathDict["path"],"")
	else:
		#load the stored scene
		load_scene("res://scenes/main/bunny/bunny_forest.tscn","")
