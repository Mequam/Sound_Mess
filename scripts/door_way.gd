extends Area2D

var current_scene = ""
var new_scene = ""
var door_name = ""
var locked = false

func _ready():
	add_to_group("door_ways")
	print("door way ready " + str(locked))
func _on_door_way_body_entered(body):
	if (!locked and body.is_in_group("player")):
		Globals.load_scene(new_scene,current_scene,door_name)


func _on_door_way_body_exited(body):
	if (locked):
		locked = false
	print("body exited " + str(locked))
