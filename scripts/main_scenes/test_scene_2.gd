extends "res://scripts/abstracts/scene.gd"
#this is the testing script for new features, it is 
#not inteanded to be clean, maintained or the like
#thik of it like chicken scratch.... but code


# Called when the node enters the scene tree for the first time.
func _ready():
	load_path = "res://scenes/main/test_scene_2.tscn"
	$StatueEnemy/statueSwitch.connect("completed_dialog",self,"statue_switch_a_complete_dialog")
	$StatueEnemy/statueSwitch.connect("completed_dialog",$OpeningDoorFront,"incriment_charge")
	$StatueEnemy/statueSwitch.connect("completed_dialog",$openingDoorSide,"incriment_charge")
	.init()
func statue_switch_a_complete_dialog(dialog):
	$StatueEnemy/statueSwitch.disconnect("completed_dialog",$OpeningDoorFront,"incriment_charge")

var test : bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test = not test
	if Input.is_action_just_pressed("DEVELOPER_ACTION"):
		$Spider_Enemy8.set_mode("die")


func _on_statueSwitch_completed_dialog(dialog):
	$StatueEnemy.corrupt()
