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
	_player_ref = val
	#print("[WARNING] node attempting to set global player ref")
func get_player_ref():
	print("[WARNING] node attempting to get global player ref")


var buffer_scene  = null setget set_load_scene,get_load_scene
func set_load_scene(val : String):
	print("[WARNING] node attempting to set the load_scene variable")
func get_load_scene():
	 print("[WARNING] node attempting to get the load_scene variable")

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

	root.remove_child(oldScene)
	#remove the previous scene
	oldScene.call_deferred("free")
	
	#prepare and load the new scene by adding the player
	buffer_scene = scene
#loads the player from the disc into global memory
#so the players state never changes
func load_player():
	_player_ref = load("res://scenes/instance/entities/player.tscn").instance()
var test : bool
#TODO: find an alternative to the _process fucntion that serves the purpose
#of getting the game to update when a new scene is buffered
func _process(delta):
	
	#we buffer the scene loading process because for some reason inputs
	#coming in from the midi node like to run on a seperate thread
	#this causes the engine to bug out and crash when loading new resources
	#on that thread
	#to counter this we buffer the scene that we want to load and then
	#run that through the _process function in order to ensure that it is runing on the main 
	#thread
	#ideally there should be a faster way to do this, some other function which
	#will allways run on the main thread to help fix these problems
	if buffer_scene != null:
		var loaded_scene : Node = load(buffer_scene).instance()
		loaded_scene.call_deferred("add_child",_player_ref)
		get_tree().root.call_deferred("add_child",loaded_scene)
		buffer_scene = null

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
