extends Node2D

var beat = 0
var load_path = ""

func _met_timeout():
	#TODO: figure out what is using the following two group function calls
	#call the plants, mainly here for mushrooms, need to see what else uses this
	get_tree().call_group("plant","run")
	#call the sprite particles
	get_tree().call_group("sprite_particle","run")
	
	#run the jute boxes so they can beep in time
	get_tree().call_group("jutebox","run")
	if (get_node("player")):
		beat += .5
		
		#call things that require the player to run
		get_tree().call_group("projectile","run",$player.position,beat)
		get_tree().call_group("generic_ai","run",$player.position,beat)
		get_tree().call_group("enemies","run",$player.position,beat)
		
		if (beat >= 4):
			beat = 0

func _ready():
	pass
func init():
	add_to_group("main_scene")
	$player.sub_beat = get_node("Met/Met").wait_time
	for node in get_tree().get_nodes_in_group("AIplayer"):
		node.sub_beat = $Met/Met.wait_time
		node.get_node("Met").wait_time = $Met/Met.wait_time
	#the previous door can set a flag which overides the default
	#load opperation and sets the player position directly
	if (LoadData.load_able_player_position != null):
		$player.position = LoadData.load_able_player_position
	elif (LoadData.prev_door_name != null):
		for n in get_tree().get_nodes_in_group("door_ways"):
			n.current_scene = load_path
			#the previous door connects to the door in the 
			#current scene
			if (n.door_name == LoadData.prev_door_name):
				#the door starts out as locked
				n.locked = true
				#the player starts out at that position
				$player.position = n.position
	$Met/Met.connect("timeout",self,"_met_timeout")
	
	for node in get_tree().get_nodes_in_group("play_idle"):
		node.get_node("AnimationPlayer").play("Idle")
	for node in get_tree().get_nodes_in_group("dialog_choice_list"):
			node.sub_beat = $Met/Met.wait_time
			node.init()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if (get_node("player")):
#		if (get_node("Met").max_time_samples >= 100):
			#get_node("player").check_inputs(delta)
