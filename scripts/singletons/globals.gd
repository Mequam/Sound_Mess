extends Node

#this script is for generic gloabal code which needs to be accessible
#from all of the project.

#I will be a happy programmer if this script stays small

#the health of the player that is saved from scene to scene
#the default value here is the initial value that the player starts with
var persistent_player_health = 5

#this id represents the game save, when saving data
#we save it in the folder user://game{game_save_id}/blah
var game_save_id : int = 0
#currently this code has functions which check to see if an action has
#just been pressed for use with the custom actions emited from
#the controlling note player
var pressed = {}
func action_just_pressed(act):
	if Input.is_action_pressed(act) and (not pressed.has(act)):
		pressed[act] = true
		return true
	return false
func release_action(act):
	if pressed.has(act):
		pressed.erase(act)
