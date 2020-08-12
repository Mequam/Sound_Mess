extends Node
var load_able_player_position = null
var prev_door_name = null
var prev_scene = null

func load_scene(scene,ps,pdn=null,lpp=null):
	prev_scene = ps
	load_able_player_position = lpp
	prev_door_name = pdn
	get_tree().change_scene(scene)
var pressed = {}
func action_just_pressed(act):
	if Input.is_action_pressed(act) and (not pressed.has(act)):
		pressed[act] = true
		return true
	return false
func release_action(act):
	if pressed.has(act):
		pressed.erase(act)
