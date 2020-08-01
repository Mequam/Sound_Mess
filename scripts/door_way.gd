extends Area2D

var current_scene = ""
var new_scene = ""
var door_name = ""

func _ready():
	add_to_group("door_ways")
func _on_door_way_body_entered(body):
	print("body enterd!")
	Globals.load_scene(new_scene,current_scene,door_name)
