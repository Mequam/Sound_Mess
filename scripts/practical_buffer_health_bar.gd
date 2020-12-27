extends "res://scripts/buffering_health_bar.gd"

#this is a buffering health bar primarily inteanded for use
#with the player

#syntactic sugar, also partly to let "legacy" code behave
#in the player
var hp setget set_hp,get_hp
func set_hp(val):
	if !inv:
		Globals.persistent_player_health = get_new_hp(val)
		sync_disp()
func get_hp():
	return Globals.persistent_player_health
