extends Node2D

func _ready():
	get_node("SingingTree").song = [
		[0,3],
		[1,-1],
		[2,3],
		[3,-1],
		[4,3]
	]
	$DialogChoiceList.sub_beat = $Met/Met.wait_time
	
var mode = 0
func _input(event):
	pass
