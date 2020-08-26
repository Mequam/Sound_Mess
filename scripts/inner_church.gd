extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	VisualServer.set_default_clear_color(Color.black)
	for node in get_tree().get_nodes_in_group("trapers"):
		node.get_node("NotePlayer").volume_db-=12
	.init()
