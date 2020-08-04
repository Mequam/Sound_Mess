extends "res://scripts/abstracts/scene.gd"

func _ready():
	var colors = [Color.aliceblue,Color.orangered,Color.aquamarine,Color.crimson]
	for t in get_tree().get_nodes_in_group("singing_trees"):
		t.set_top_color(colors[rand_range(0,len(colors))])
	for tr in get_tree().get_nodes_in_group("trapers"):
		tr.leg_color = Color(1, 0.423529, 0)
	for g in get_tree().get_nodes_in_group("grass"):
		g.modulate = Color(1, 0.423529, 0)
	$note_a.song = [[0,0],[2,null]]
	$note_b.song = [[2,2],[4,null]]
	$note_c.song = [[4,5],[6,null]]
	
	$note_d.song = [[6,-1],[8,null]]
	
	$note_e.song = [[8,0],[10,null]]
	$note_f.song = [[10,2],[12,null]]
	$note_g.song = [[12,5],[14,null]]
	
	$note_h.song = [[14,-2],[0,null]]
	
	for tree in 'abcdefgh':
		var t = get_node("note_"+tree)
		t.max_beat = 16
		t.singing = true
		
	.init()
