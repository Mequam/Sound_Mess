extends "res://scripts/abstracts/scene.gd"
#this is the testing script for new features, it is 
#not inteanded to be clean, maintained or the like
#thik of it like chicken scratch.... but code


# Called when the node enters the scene tree for the first time.
func _ready():
	load_path = "res://scenes/main/test_scene_2.tscn"
	$FallingCarrot.speed = 400
	$FallingCarrot.move_vec = Vector2(0,1)
	$FallingCarrot.fall()
	.init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		$SiloBoss.corrupt()
	elif Input.is_key_pressed(KEY_0):
		$SiloBoss.mode = "shake"
