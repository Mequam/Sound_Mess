extends "res://scripts/abstracts/bunny_forest.gd"

func _ready():
	$church_yard.door_name = "D"
	$church_yard.new_scene = "res://scenes/main/bunny/church_yard.tscn"
	
	$statue_path1.door_name = "A"
	$statue_path1.new_scene = "res://scenes/main/bunny/statue_motif/statue_road1.tscn"
	
	$statue_path_1_hidden.door_name = "B"
	$statue_path_1_hidden.new_scene = "res://scenes/main/bunny/statue_motif/statue_road1.tscn"
	
	#sync the statues and their door counters
	$statueSwitch.connect("completed_dialog",$openingDoorSide,"incriment_charge")
	$statueSwitch2.connect("completed_dialog",$openingDoorSide2,"incriment_charge")
	
	$statueSwitch3.connect("completed_dialog",$OpeningDoorFront2,"incriment_charge")
	$StatueEnemy/statueSwitch.connect("completed_dialog",$OpeningDoorFront,"incriment_charge")
	.init()
func _process(delta):
	if Input.is_action_just_pressed("DEVELOPER_ACTION"):
		$StatueEnemy.corrupt()