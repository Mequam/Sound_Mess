extends "res://scripts/abstracts/bunny_forest.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$door_to_tall_grass.door_name = "B"
	$door_to_tall_grass.new_scene = "res://scenes/main/bunny/grass_field.tscn"
	.init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
