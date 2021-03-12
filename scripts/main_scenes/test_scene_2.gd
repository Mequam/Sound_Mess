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
	
	$StatueEnemy/statueSwitch.connect("completed_dialog",self,"statue_switch_a_complete_dialog")
	.init()
func statue_switch_a_complete_dialog(dialog):
	print("[test_scene_2] finished dialog!")

var test : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test = not test
	if Input.is_action_just_pressed("DEVELOPER_ACTION"):
		$StatueEnemy.corrupt()


func _on_statueSwitch_completed_dialog(dialog):
	$StatueEnemy.corrupt()
