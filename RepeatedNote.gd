extends "res://scripts/sameModeDialogBox.gd"
#this script is a dialog that changes the notes that it has dependent on 
#a function call
#in this case the node is set up to repeat the same note x times

func set_repeat(note : int,count : int,speed : int = 1)->void:
	notes = []
	for i in range(0,count):
		notes.append([note,speed])
