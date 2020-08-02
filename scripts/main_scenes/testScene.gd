extends "res://scripts/abstracts/scene.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_path = "res://scenes/main/test_2d_space.tscn"
	$house_a/bunny_house_a/door_way.door_name = "A"
	$house_a/bunny_house_a/door_way.new_scene = "res://scenes/main/test_scene_2.tscn"
	$house_a/bunny_house_a/door_way.player_position = Vector2(483.252,-196.213)
	for node in get_tree().get_nodes_in_group("trapers"):
		node.leg_color = Color.darkgreen
	
	get_node("SingingTree").song = [
		[0,3],
		[1,-1],
		[2,3],
		[3,-1],
		[4,3]
	]
	$SingingTree.set_top_color(Color.violet)
	$SingingTree3.set_top_color(Color.aqua)
	$SingingTree4.set_top_color(Color.orangered)
	$SingingTree2.set_top_color(Color.lightcoral)
	
	.init()
