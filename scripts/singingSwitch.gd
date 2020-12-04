extends "res://scripts/colSwitchAnim.gd"
var player : Node = null
func ready():
	#make sure that we start off not enabled
	$DialogChoiceList.enabled = false

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
	set_on(not get_on())
	$switchAsset/AnimationPlayer.play("stateChange")
	$DialogChoiceList.enabled = false
	#the player has no need to keep talking
	if player != null:
		player.talking = false
