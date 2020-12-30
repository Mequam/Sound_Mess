extends "res://scripts/buffering_health_bar.gd"

#this is a buffering health bar primarily inteanded for use
#with the player

var hp : int = 5 setget set_hp,get_hp
func set_hp(val):
	if !inv:
		hp = get_new_hp(val)
		sync_disp()
func get_hp():
	return hp
func _ready():
	sync_disp()
