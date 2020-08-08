extends "res://scripts/abstracts/bunny_forest.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$bunny_forest.door_name = "A"
	$bunny_forest.new_scene = "res://scenes/main/bunny/bunny_forest.tscn"
	.init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
