extends "res://scripts/abstracts/save_state_node.gd"
#this file contains the death save state behavior of every boss
func serialize()->Dictionary:
	return {"mode" : get_parent().mode}
#bosses do not remove on save death, instead the node is alerted that it has
#died
func save_death()->void:
	.save_data_path_dict(.get_save_path(),{"mode":"dead"})
