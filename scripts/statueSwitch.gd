extends Node2D
signal completed_dialog

#syntactic sugar for toggling visibility
var enabled : bool setget set_enabled,get_enabled
func set_enabled(val : bool)->void:
	visible = val
	if not visible:
		$singingSwitch.collision_mask = 0
	else:
		#reset the switch
		$singingSwitch.collision_mask = $singingSwitch.gen_col_mask()
func get_enabled()->bool:
	return visible

var statue_mode : int = 2 setget set_statue_mode, get_statue_mode
func set_statue_mode(val : int)->void:
	#display the proper statue
	$VariableStatue.display_mode(val)
	#save our mode
	statue_mode = val
func get_statue_mode()->int:
	return statue_mode
#overloadable ready
func init():
	#sync our state
	set_statue_mode(statue_mode)
	#use the children after our second child as songs
	$singingSwitch/DialogChoiceList.init_node(Globals.get_scene_sub_beat(),self,3)
func _ready():
	init()
func _on_DialogChoiceList_completed_dialog(dialog):
	#pass along the signal
	emit_signal("completed_dialog",dialog)
