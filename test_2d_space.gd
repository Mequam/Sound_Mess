extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var beat = 0
func _met_timeout():
	get_node("Blipper").target = get_node("player").position
	get_node("Blipper")._met_process()
	get_tree().call_group("sprite_particle","run")
	if (get_node("player")):
		beat += .5
		get_tree().call_group("plants","run")
		#call the players met process
		get_node("player")._met_process(beat)
		for node in get_tree().get_nodes_in_group("enemies"):
			node.run(get_node("player").position,beat)
		if (beat >= 4):
			beat = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Blipper").mode = "evil"
	get_node("player").sub_beat = get_node("Met/Met").wait_time
	get_node("player/NotePlayer").mode = 1
	get_node("SingingTree").song = [
		[0,3],
		[1,-1],
		[2,3],
		[3,-1],
		[4,3]
	]
	get_node("Met/Met").connect("timeout",self,"_met_timeout")
	for combo in get_node("player/ComboTracker").combos:
		print('[' + combo.name + '] ')
		for act in combo.action_list:
			print('->' + act.action)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_node("player")):
		if (get_node("Met").max_time_samples >= 100):
			get_node("player").check_inputs(delta,get_node("Met/Met").time_left)
#get_node("testTree").play_hard(3)
	#if (get_node("testTree").position.distance_to(get_local_mouse_position()) < 10 and get_node("testTree").playing == -1):
#	elif (get_node("testTree").position.distance_to(get_local_mouse_position()) > 10):
#		get_node("testTree").stop()
		
