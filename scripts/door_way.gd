extends Area2D

#this script runs the dorrs that connect
#different scenes together
#effectivly they function as load zones

var current_scene = ""
var new_scene = ""
var door_name = ""
var locked = false

func _ready():
	add_to_group("door_ways")
	print("door way ready " + str(locked))
func _on_door_way_body_entered(body):
	if (new_scene != "" and !locked and body.is_in_group("player")):
		LoadData.load_scene(new_scene,current_scene,door_name)


func _on_door_way_body_exited(body):
	if (locked):
		locked = false
