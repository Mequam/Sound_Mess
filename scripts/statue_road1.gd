extends "res://scripts/abstracts/bunny_forest.gd"


func _ready():
	#TODO:
	#getting these repeated dialog notes working from the root is a PAIN
	var repeatDialog : Node = $statueSwitch/singingSwitch/DialogChoiceList/repeatingDialog
	repeatDialog.set_repeat(repeatDialog.scale_math.ActionDegree.MOVE_LEFT,3)
	$statueSwitch/singingSwitch/DialogChoiceList.init($Met/Met.wait_time)
	
	#incriments the or door
	$statueSwitch.connect("completed_dialog",$openingDoorSide,"incriment_charge")
	
	repeatDialog  = $statueSwitch2/singingSwitch/DialogChoiceList/repeatingDialog
	repeatDialog.set_repeat(repeatDialog.scale_math.ActionDegree.MOVE_RIGHT,3)
	$statueSwitch2/singingSwitch/DialogChoiceList.init($Met/Met.wait_time)
	
	#incriments the or door
	$statueSwitch2.connect("completed_dialog",$openingDoorSide,"incriment_charge")
	
	#both statues contribute to opening the main door
	$statueSwitch2.connect("completed_dialog",$OpeningDoorFront,"incriment_charge")
	$statueSwitch.connect("completed_dialog",$OpeningDoorFront,"incriment_charge")
	$StatueEnemy/statueSwitch.connect("completed_dialog",$OpeningDoorFront2,"incriment_charge")
#each statue can only contribute to the doors incriment once, disconnect them after
#they incriment the door
func _on_statueSwitch2_completed_dialog(dialog):
	$statueSwitch2.disconnect("completed_dialog",$OpeningDoorFront,"incriment_charge")
func _on_statueSwitch_completed_dialog(dialog):
	$statueSwitch.disconnect("completed_dialog",$OpeningDoorFront,"incriment_charge")
