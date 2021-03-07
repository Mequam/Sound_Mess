extends "res://scripts/sameModeDialogBox.gd"


func _ready():
	print("[full_scale] running ready")
	get_tree().get_nodes_in_group("player")[0].global_position = global_position
	notes = []
	#make a scale
	for i in range(0,7):
		notes.append([7-i,1])
