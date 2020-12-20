extends "res://scripts/abstracts/bunny_forest.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#set up the doors
	$bunny_forest.door_name = "A"
	$bunny_forest.new_scene = "res://scenes/main/bunny/bunny_forest.tscn"
	
	$bcd.new_scene = "res://scenes/main/bunny/inner_church.tscn"
	$bcd.door_name = "B"
	
	$carrot_fields.new_scene = "res://scenes/main/bunny/carrot_motif/crop_fields.tscn"
	$carrot_fields.door_name = "C"
	.init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
