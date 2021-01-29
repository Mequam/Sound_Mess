extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$outer_fieldsHigh.door_name = "F"
	$outer_fieldsHigh.new_scene = "res://scenes/main/bunny/carrot_motif/outer_fields.tscn"
	
	$outer_fieldsLow.door_name = "E"
	$outer_fieldsLow.new_scene = "res://scenes/main/bunny/carrot_motif/outer_fields.tscn"
	.init()
