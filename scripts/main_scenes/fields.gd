extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	$door_church_yard.new_scene = "res://scenes/main/bunny/church_yard.tscn"
	$door_church_yard.door_name = "C"
	.init()
