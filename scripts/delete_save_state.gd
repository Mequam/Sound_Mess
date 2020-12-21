extends "res://scripts/abstracts/save_state_node.gd"
func load_data() -> void:
	var loaded_dict = read_data()
	if (not loaded_dict.has("exists")) or not loaded_dict["exists"]:
		get_parent().queue_free()
	else:
		#call the original load data
		.load_data()
func _ready():
	load_data()
