extends "res://scripts/abstracts/save_state_node.gd"
#this file is the unique save and load behavior of the bunny boss
#leave it visible for all to see when it dies


func serialize()->Dictionary:
	return {"dead":get_parent().mode=="Dead"}
func load_data() -> void:
	var read = read_data()
	if read.has("dead") and read["dead"]:
		#lower case mode so we do not play the animation and simply
		#do not run any code at all by passing a state which
		#does not exist
		get_parent().mode = "dead"
func _ready():
	pass
