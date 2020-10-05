extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$door_church_yard.new_scene = "res://scenes/main/bunny/church_yard.tscn"
	$door_church_yard.door_name = "C"
	
	$fields_door.new_scene = "res://scenes/main/bunny/grass_field.tscn"
	$fields_door.door_name = "A"
	.init()
