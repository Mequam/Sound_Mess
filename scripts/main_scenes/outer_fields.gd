extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$crop_fields.door_name = "D"
	$crop_fields.new_scene = "res://scenes/main/bunny/carrot_motif/crop_fields.tscn"

	.init()
