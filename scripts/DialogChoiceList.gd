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
var enabled = false setget set_enabled, get_enabled

#syntactic suguar signal so we dont have to get child nodes when
#connecting signals elsewhere
signal completed_dialog
#only alerts the game that the dialog was not completed, does not pass an argument
signal completed_dialog_no_arg
func set_enabled(val):
	visible = val
func get_enabled():
	return visible
func _ready():
	#this could be done through the editor,
	#but because I am forgetfull we make sure that the node starts out as not visible
	visible = false
	add_to_group("dialog_choice_list")
	init(Globals.get_scene_sub_beat())

#this function uses another nodes children to initilize the dialog choice list
#NOTE: it ultimatly moves those children to be children of the dialogChouice List
#keep this in mind when using it
func init_node(sub_beat,node : Node2D,children_offset : int = 0)->void:
	#move all nodes at and after the children offset under us
	while node.get_child(children_offset): #use the while loop for more fine control over the iterator
		var child : Node2D = (node.get_child(children_offset) as Node2D) #tldr this should be a 2d node
		#save the nodes position
		var global_pos : Vector2= child.global_position
		#remove the child from our tree
		node.remove_child(child)
		#add it under the dialog choice list
		add_child(child)
		#restore the nodes position to account for any scale shifting
		child.global_position = global_pos
	#now that we stole their children, run the initilization
	init(sub_beat)

func init(sub_beat):
	$ComboTracker.combos.clear()
	
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
	if (visible):
		$ComboTracker.check_inputs(delta)

func _on_ComboTracker_combo_found(cmbName):
	emit_signal("completed_dialog",cmbName)
	emit_signal("completed_dialog_no_arg")
