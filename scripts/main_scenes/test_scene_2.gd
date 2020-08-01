extends "res://scripts/abstracts/scene.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_path = "res://scenes/main/test_scene_2.tscn"
	$TS1/door_way.door_name="A"
	$TS1/door_way.new_scene = "res://scenes/main/test_scene_2.tscn"
	._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
