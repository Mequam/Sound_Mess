extends "res://scripts/abstracts/scene_save_state.gd"
#this script serves as the serialization function for the silo
#boss fight zone
func serialize() -> Dictionary:
	return {"first_visit":get_parent().first_visit}
