extends Node2D


#simple script to make it so we can modulate all of the children at once
var _modulate = Vector3(255,255,255)

var mod setget set_mod,get_mod

func get_mod(): 
	return _modulate
func set_mod(val):
	_modulate = val
	sync_mods()

func sync_mods():
	for n in get_children():
		n.modulate = _modulate

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
