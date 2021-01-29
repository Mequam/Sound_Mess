extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$crop_fields.door_name = "D"
	$crop_fields.new_scene = "res://scenes/main/bunny/carrot_motif/crop_fields.tscn"

	#these both go to the same scene, but in two diff places
	$up_carrot_path.door_name = "E"
	$up_carrot_path.new_scene = "res://scenes/main/bunny/carrot_motif/silo_fields.tscn"
	$side_carrot_path.door_name = "F"
	$side_carrot_path.new_scene = "res://scenes/main/bunny/carrot_motif/silo_fields.tscn"
	.init()
