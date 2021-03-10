extends "res://scripts/sameModeDialogBox.gd"


func _ready():
	notes = []
	#make a scale
	for i in range(0,7):
		notes.append([7-i,1])
	print("[full_scale] notes: " + str(notes))
