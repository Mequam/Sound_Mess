extends "res://scripts/health_bar.gd"
func set_hp(val):
	Globals.persistent_player_health = get_new_hp(val,Globals.persistent_player_health)
	sync_disp()
func get_hp():
	return Globals.persistent_player_health
