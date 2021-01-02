extends "res://scripts/abstracts/bunny_forest.gd"

func _ready():
	$note_a/JuteBox.song = [[0,0],[2,null]]
	$note_b/JuteBox.song = [[2,2],[4,null]]
	$note_c/JuteBox.song = [[4,5],[6,null]]
	
	$note_d/JuteBox.song = [[6,-1],[8,null]]
	
	$note_e/JuteBox.song = [[8,0],[10,null]]
	$note_f/JuteBox.song = [[10,2],[12,null]]
	$note_g/JuteBox.song = [[12,5],[14,null]]
	
	$note_h/JuteBox.song = [[14,-2],[0,null]]
	
	for tree in 'abcdefgh':
		var t = get_node("note_"+tree).get_node("JuteBox")
		t.max_beat = 16
		t.singing = true
	
	$bunny_church.door_name = "A"
	$bunny_church.new_scene = "res://scenes/main/bunny/church_yard.tscn"
	.init()
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_L:
			LoadData.load_scene("res://scenes/main/bunny/church_yard.tscn",load_path)
