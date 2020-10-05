extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$door_way_a.new_scene = "res://scenes/main/bunny/crop_fields.tscn"
	$door_way_a.door_name = "A"
	.init()
