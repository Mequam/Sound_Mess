extends "res://scripts/abstracts/bunny_forest.gd"
func init():
	$mid_door_statue.connect("completed_dialog",$mid_door,"incriment_charge")
	
	$secret_door_1.connect("completed_dialog",$SecrativeDoor,"incriment_charge")
	$secret_door_2.connect("completed_dialog",$SecrativeDoor,"incriment_charge")
	$secret_door_3.connect("completed_dialog",$SecrativeDoor,"incriment_charge")
	
	.init()
