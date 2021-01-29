extends "res://scripts/abstracts/generic_area.gd"

func gen_col_layer():
	return 0
#we will only respond to the player
func gen_col_mask():
	return col_math.Layer.PLAYER

#this script is for a node that increases the alpha of the parent
#node when the player enters a certain area

#NOTE: when using this node make sure to give it a shape!

#how many bodies are inside our area
var _dim_count : int = 0 setget set_dim_count,get_dim_count
func set_dim_count(val : int) -> void:
	#every body has left
	if val == 0 and _dim_count != 0:
		get_parent().modulate.a *= 1.25
	#we have people from no people!
	elif val != 0 and _dim_count == 0:
		get_parent().modulate.a /= 1.25
	_dim_count = val
func get_dim_count()->int:
	return _dim_count

func _on_dimer_body_entered(body):
	set_dim_count(get_dim_count()+1)
func _on_dimer_body_exited(body):
	set_dim_count(get_dim_count()-1)
