extends "res://scripts/ComoTracker.gd"
func _ready():
	#we want to recive midi input calls
	add_to_group("player_note_action_listener")
func _player_action_pressed(action_degree):
	match_combo("NOTE_" + str(action_degree+7),false)
func _player_action_released(action_degree):
	match_combo("NOTE_" + str(action_degree+7),true)
#incriment time for our caclulations
func check_inputs(delta):
	time+=delta
