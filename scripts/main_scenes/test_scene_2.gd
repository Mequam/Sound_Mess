extends "res://scripts/abstracts/scene.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_path = "res://scenes/main/test_scene_2.tscn"
	$SingingTree/door_way.door_name="A"
	$SingingTree/door_way.new_scene = "res://scenes/main/test_2d_space.tscn"
	$DialogChoiceList.sub_beat = $Met/Met.wait_time
	$DialogChoiceList.init()
	
	$player.talking = true
	.init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
