extends Area2D

var current_scene = ""
var new_scene = ""
var door_name = ""
var player_position = Vector2(0,0)
func _ready():
	add_to_group("door_ways")
	player_position = position
func _on_door_way_body_entered(body):
	Globals.load_scene(new_scene,current_scene,door_name)
