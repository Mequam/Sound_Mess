extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$crop_fields.door_name = "D"
	$crop_fields.new_scene = "res://scenes/main/bunny/carrot_motif/crop_fields.tscn"
	
	#pre-corrupt the line of evil carrots at the bottom
	for i in range(10,15):
		get_node("evil_carrot" + str(i)).corrupt()
	.init()
