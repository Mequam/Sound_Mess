extends "res://scripts/abstracts/scene.gd"


func init():
	var colors = [Color.aliceblue,Color.orangered,Color.aquamarine,Color.crimson]
	for t in get_tree().get_nodes_in_group("singing_trees"):
		t.set_top_color(colors[rand_range(0,len(colors))])
	for tr in get_tree().get_nodes_in_group("trapers"):
		tr.leg_color = Color(1, 0.423529, 0)
	for g in get_tree().get_nodes_in_group("grass"):
		g.modulate = Color(1, 0.423529, 0)
	.init()
