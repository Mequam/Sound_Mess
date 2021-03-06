extends Node2D
#this script is a visual script indicating to the player which avatar
#they will be switching to

#basically this is a sprite that changes how it looks to match the given
#avatar enumerator

var ava_math = preload("res://scripts/ava_code_math.gd") 
func display_avatar(code : int):
	#if there is ANY statue, we kill it
	for node in get_children():
		node.queue_free()
	#add the new statue
	add_child(load(ava_math.avatar_enum2transPath(code)).instance())
