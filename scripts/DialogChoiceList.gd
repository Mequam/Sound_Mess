extends Node2D
#this script is for the dialog choice list.
#this node is designed to have a series of dialogBox nodes as its children
#it will then display those dialog boxes and emit the signal name of the 
#dialog box option when that dialog is completed

#the mode that the dialog boxes will be displayed as
#start off as major with a mode of 1
var mode = 1
var sub_beat = 1
var onColor = Color.orangered
var offColor = Color.white
var enabled = true setget set_enabled, get_enabled
func set_enabled(val):
	enabled = val
	visible = enabled
func get_enabled():
	return enabled

func init():
	for node in get_children():
		if node.name != "ComboTracker":
			#sadly we must change a state in order to pass this information
			#do to the nature of event programing
			node.onColor = onColor
			node.offColor = offColor

			var combo = node.getCombo(sub_beat)

			#make sure that the node syncs scores properly
			combo.connect("score_changed",node,"syncScoreColorDbl")
			
			#create the combo for our combo tracker
			$ComboTracker.combos.append(combo)
			
			#display the combos stored in the nodes
			node.updateDisp(mode)

func _process(delta):
	$ComboTracker.check_inputs(delta)

func _on_ComboTracker_combo_found(cmbName):
	print("[completed dialog] " + cmbName)
