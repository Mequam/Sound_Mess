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
	$Sprite/AnimationPlayer.play("Transform")
	.init()
var test : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test = not test
	if Input.is_action_just_pressed("DEVELOPER_ACTION"):
		if test:
			$Sprite/AnimationPlayer.play("Idle")
		else:
			$Sprite/AnimationPlayer.play("Spin")
