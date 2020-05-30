extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flip_h setget set_flip_h,get_flip_h
func set_flip_h(val):
	if (val and scale.x > 0):
		scale.x *= -1
	elif (!val and scale.x < 0):
		scale.x *= -1
func get_flip_h():
	return scale.x < 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
