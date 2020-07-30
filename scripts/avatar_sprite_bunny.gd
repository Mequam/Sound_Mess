extends Node2D

var burrow_effect = load("res://scenes/assets/burrow/burrow_effect.tscn")

func burrow_dir(dir,dist=1000):
	var be = burrow_effect.instance()
	be.dist = dist
	be.position = position-dir*dist
	be.dir = dir

	get_parent().add_child(be)
