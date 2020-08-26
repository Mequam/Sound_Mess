extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	VisualServer.set_default_clear_color(Color.black)
	for node in get_tree().get_nodes_in_group("trapers"):
		node.get_node("NotePlayer").volume_db-=12
	$door_way.new_scene = "res://scenes/main/bunny/church_yard.tscn"
	$door_way.door_name = "B"
	.init()
