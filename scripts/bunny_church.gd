extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	var colors = [Color.orangered,Color.antiquewhite,Color.aqua]
	for n in range(2,8):
		var node = get_node("bunny_window" + str(n))
		node.window_color = colors[i]
		node.get_node("AnimationPlayer").stop()
		i = (i+1)%3
	$bunny_window.window_color = Color.aqua
	$bunny_window/AnimationPlayer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
