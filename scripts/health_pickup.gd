extends "res://scripts/abstracts/pickup.gd"
#the amount that we heal the player
var heal_amount = 2
func edit_body(player):
	player.heal(heal_amount)
	#TODO: play the root chord here
	.edit_body(player)
func _ready():
	#set up the root chord for the health pick up
	$JuteBox.song = [[1,2],[2,null],[9,0],[10,null],[17,4],[18,null]]
	$JuteBox.max_beat = 24
	$JuteBox.singing = true
