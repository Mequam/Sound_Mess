extends Node
var load_able_player_position = null
var prev_door_name = null
var prev_scene = null

func load_scene(scene,ps,pdn=null,lpp=null):
	prev_scene = ps
	load_able_player_position = lpp
	prev_door_name = pdn
	get_tree().change_scene(scene)
