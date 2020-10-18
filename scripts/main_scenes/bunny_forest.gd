extends "res://scripts/abstracts/bunny_forest.gd"

func _ready():
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
	
	$bunny_church.door_name = "A"
	$bunny_church.new_scene = "res://scenes/main/bunny/church_yard.tscn"
	.init()
