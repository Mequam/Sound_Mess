extends Node2D
#this is a very simple node that is inteanded to be a statue of any
#mode that we give it (bunny,bird, ect.) and function as a normal statue asset

var ava_math = preload("res://scripts/ava_code_math.gd")
func display_mode(mode : int)->void:
	if (get_child(0)):
		get_child(0).queue_free()
	var to_add : Node2D = ava_math.avatar_enum2statueNode(mode)
	
	#scale the node by the required amount
	to_add.scale*=get_scale_adjustments(mode)
	
	#add it as a child
	add_child(to_add)
func play_emited():
	get_child(0).get_node("AnimationPlayer").play("emited")
#returns scale adgjustments for the given avatar mode statue sprites
func get_scale_adjustments(mode : int)->Vector2:
	match mode:
		1:
			return Vector2(0.5,0.5)
	return Vector2(1,1)
