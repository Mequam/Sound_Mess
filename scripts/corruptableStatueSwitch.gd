extends "res://scripts/statueSwitch.gd"
#this node is a statue switch that is used as an asset inside of the corruptable enemy
#the only real change with this script is that we get our children from our parents parent
func init():
	pass
#when the parent is ready move nodes around
func _on_StatueEnemy_ready():
	var parent = get_parent()
	#make sure scale does not get all wonky
	for i in range(7,parent.get_child_count()):
		parent.get_child(i).scale /= scale
	
	#sync our state
	set_statue_mode(statue_mode)
	#use the children after our second child as songs
	$singingSwitch/DialogChoiceList.init_node(Globals.get_scene_sub_beat(),
	parent, #this is the different line, use the statue enemy as the root to begin moving nodes from
	7) #start on node 6 because we have 5 nodes by default
