extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func on_col(body):
	print("struck " + str(body))
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("weapon")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
