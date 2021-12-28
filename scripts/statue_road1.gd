extends BunnyForest
var switch_ref : Node2D
var switch_ref2 : Node2D

func _ready():
	#set up the doors
	$statue_path_enterence.door_name = "A"
	$statue_path_enterence.new_scene = "res://scenes/main/bunny/statue_motif/entering_statue_road.tscn"
	
	$statue_path_enterence_hidden.door_name = "B"
	$statue_path_enterence_hidden.new_scene = "res://scenes/main/bunny/statue_motif/entering_statue_road.tscn"
	
	$statue_road_2.door_name = "C"
	$statue_road_2.new_scene = ""
	
	#set up the switch connections
	#TODO:
	#getting these repeated dialog notes working from the root is a PAIN
	
	var repeatDialog : Node = $statueSwitch/singingSwitch/DialogChoiceList/repeatingDialog
	repeatDialog.set_repeat(repeatDialog.scale_math.ActionDegree.MOVE_LEFT,3)
	$statueSwitch/singingSwitch/DialogChoiceList.init($Met/Met.wait_time)
	
	#incriments the SIDE door
	$statueSwitch.connect("completed_dialog",$openingDoorSide,"incriment_charge")
	
	repeatDialog = $statueSwitch2/singingSwitch/DialogChoiceList/repeatingDialog
	repeatDialog.set_repeat(repeatDialog.scale_math.ActionDegree.MOVE_RIGHT,3)
	$statueSwitch2/singingSwitch/DialogChoiceList.init($Met/Met.wait_time)
	
	#incriments the SIDE door
	$statueSwitch2.connect("completed_dialog",$openingDoorSide,"incriment_charge")
	
	#both statues contribute to opening the FRONT door
	$statueSwitch2.connect("completed_dialog",$OpeningDoorFront,"incriment_charge")
	$statueSwitch.connect("completed_dialog",$OpeningDoorFront,"incriment_charge")
	
	#Opens the second front door
	$StatueEnemy/statueSwitch.connect("completed_dialog",$OpeningDoorFront2,"incriment_charge")

	$statueSwitch3.connect("completed_dialog",$openingDoorSide2,"incriment_charge")
	
	
	#the connections for the statue switch enemies that need to be buffered
	#so they are one time connections
	switch_ref = $StatueEnemy2.get_node("statueSwitch")
	switch_ref.connect("completed_dialog",$OpeningDoorFront3,"incriment_charge")
	
	switch_ref2 = $StatueEnemy3.get_node("statueSwitch")
	switch_ref2.connect("completed_dialog",$OpeningDoorFront3,"incriment_charge")

	switch_ref.connect("completed_dialog",self,"_on_switch_ref_completed_dialog")
	switch_ref2.connect("completed_dialog",self,"_on_switch_ref2_completed_dialog")
	#call the init function
	init()
#each statue can only contribute to the doors incriment once, disconnect them after
#they incriment the door
func _on_statueSwitch2_completed_dialog(dialog):
	$statueSwitch2.disconnect("completed_dialog",$OpeningDoorFront,"incriment_charge")
func _on_statueSwitch_completed_dialog(dialog):
	$statueSwitch.disconnect("completed_dialog",$OpeningDoorFront,"incriment_charge")
func _on_switch_ref_completed_dialog(dialog):
	switch_ref.disconnect("completed_dialog",$OpeningDoorFront3,"incriment_charge")
func _on_switch_ref2_completed_dialog(dialog):
	switch_ref2.disconnect("completed_dialog",$OpeningDoorFront3,"incriment_charge")
