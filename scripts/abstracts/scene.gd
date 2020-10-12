extends Node2D

var beat = 0
var load_path = ""

func _met_timeout():
	#call
	get_tree().call_group("sprite_particle","run")
	get_tree().call_group("plants","run")
	
	if (get_node("player")):
		beat += .5
		
		#call the players met process
		get_node("player")._met_process(beat)
		
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
	if (Globals.load_able_player_position != null):
		$player.position = Globals.load_able_player_position
	elif (Globals.prev_door_name != null):
		print("checking the previous door name against names in the scene as " + load_path)
		for n in get_tree().get_nodes_in_group("door_ways"):
			n.current_scene = load_path
			if (n.door_name == Globals.prev_door_name):
				n.locked = true
				$player.position = n.position
	$Met/Met.connect("timeout",self,"_met_timeout")
	
	for node in get_tree().get_nodes_in_group("play_idle"):
		node.get_node("AnimationPlayer").play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if (get_node("player")):
#		if (get_node("Met").max_time_samples >= 100):
			#get_node("player").check_inputs(delta)
