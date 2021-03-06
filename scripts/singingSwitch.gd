extends "res://scripts/abstracts/generic_area.gd"
#this area puppetires a dialog choice box and toggles its enable/disable
#depending on the players position
func gen_col_layer()->int:
	return 0
func gen_col_mask()->int:
	return col_math.Layer.PLAYER
var player : Node = null
func ready():
	#make sure that we start off not enabled
	$DialogChoiceList.enabled = false
	#for some reason this line does not work properly, prolly has somthing to do with node order
	#$DialogChoiceList.connect("completed_dialog",self,"_on_DialogChoiceList_completed_dialog")
func _on_singingSwitch_body_entered(body):
	if body.is_in_group("player"):
		body.talking = true
		$DialogChoiceList.enabled = true
		#store a reerence to the player for later
		player = body

func _on_singingSwitch_body_exited(body):
	if body.is_in_group("player"):
		body.talking = false
		$DialogChoiceList.enabled = false
		#clear out our reference to the player
		player = null

func _on_DialogChoiceList_completed_dialog(sentance):
	#the player has no need to keep talking
	if player != null:
		player.talking = false
