extends "res://scripts/practicalDialog.gd"

func _ready():
	var qn = 1
	#note to self: find a better way to notate music with less repitition
	#theres a lot of similar patterns in here, it would be nice to weed them
	#out so it was easier to notate
	notes = [[6,qn],[1,qn],[6,qn],[4,qn], #kill spiders
			[1,qn],[2,qn],[1,qn],[2,qn],[0,qn]] #play spider deaths
