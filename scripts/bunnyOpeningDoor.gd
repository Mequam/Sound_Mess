extends "res://scripts/abstracts/generic_static.gd"
#this script controlls the opening door used primaraly in the bunny
#statue zone to block the players progress until it all of the charges in the 
#door are open

var charge : int = 0  setget set_charge,get_charge
func set_charge(val : int):
	charge = val
	_syncDisp()
func get_charge():
	return charge

#syntactic sugar function for connecting signals
func incriment_charge(val):
	set_charge(charge + 1)
	
#internal function that syncs our displayed charges with our charge score
func _syncDisp():
	for i in range(3,charge+3):
		#display our charges
		if get_child(i):
			get_child(i).set_on(true)
		else:
			#no need to continue looping we have exhausted the number of children
			#we have
			break
	if charge >= get_child_count()-3:
		$Sprite.play("Open")
func _ready():
	pass


func _on_Sprite_animation_finished():
	collision_layer = 0
	collision_mask = 0
