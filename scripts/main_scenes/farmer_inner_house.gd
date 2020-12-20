extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$crop_fields_door.new_scene = "res://scenes/main/bunny/carrot_motif/crop_fields.tscn"
	$crop_fields_door.door_name = "B"
	.init()
