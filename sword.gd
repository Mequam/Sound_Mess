extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_strike(thing):
	if (thing.has_method("on_col")):
		thing.on_col(self)
func _on_Sword_area_entered(area):
	print("struck" + str(area))
	_on_strike(area)

func _on_Sword_body_entered(body):
	print("struck" + str(body))
	_on_strike(body)
