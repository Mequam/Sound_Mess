extends Node2D

var beat = 0
var player_position = Vector2(0,0)

func _met_timeout():
	get_tree().call_group("sprite_particle","run")
	get_tree().call_group("plants","run")
	if (get_node("player")):
		beat += .5
		#call the players met process
		get_node("player")._met_process(beat)
		get_tree().call_group("projectile","run",$player.position,beat)
		get_tree().call_group("generic_ai","run",$player.position,beat)
		get_tree().call_group("enemies","run",$player.position,beat)
		if (beat >= 4):
			beat = 0

func _ready():
	#for node in get_tree().get_nodes_in_group("trapers"):
	#	node.leg_color = Color.darkgreen
	
	$player.sub_beat = get_node("Met/Met").wait_time
	if (player_position):
		$player.position = player_position
	$Met/Met.connect("timeout",self,"_met_timeout")
	
	#get_node("SingingTree").song = [
	#	[0,3],
	#	[1,-1],
	#	[2,3],
	#	[3,-1],
	#	[4,3]
	#]
	#$SingingTree.set_top_color(Color.violet)
	#$SingingTree3.set_top_color(Color.aqua)
	#$SingingTree4.set_top_color(Color.orangered)
	#$SingingTree2.set_top_color(Color.lightcoral)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_node("player")):
		if (get_node("Met").max_time_samples >= 100):
			get_node("player").check_inputs(delta,get_node("Met/Met").time_left)
