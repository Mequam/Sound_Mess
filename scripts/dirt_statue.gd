extends Node2D
var mode : int = 1 setget set_mode,get_mode
func set_mode(val : int):
	$VariableStatue.display_mode(val)
	mode = val
func get_mode()->int:
	return mode

func _ready():
	#sync our state
	set_mode(mode)
