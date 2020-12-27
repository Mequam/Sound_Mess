extends "res://scripts/health_bar.gd"

#this is a practical hp bar that stores it's hp inside the given class and
#does not buffer

var hp : int = 5 setget set_hp,get_hp
func set_hp(val):
		hp = get_new_hp(val)
		sync_disp()
func get_hp():
	return hp
