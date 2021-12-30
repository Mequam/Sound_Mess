extends VBoxContainer
#this script is an hbox container that cycles focus when the user
#presses the arrow key

#this is set to true when any of our children come into focus
var _children_in_focus : bool = false

#the index of the child node that is focused
#-1 indicates no focus
var focus_node_index : int = -1 setget set_focus_node_index,get_focus_node_index
func set_focus_node_index(val : int) -> void:
	focus_node_index = val % get_child_count()
	get_child(focus_node_index).grab_focus()
func get_focus_node_index()->int:
	return focus_node_index

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0,get_child_count()):
		var child = get_child(i)
		(child as Control).connect("focus_entered",self,"child_focus_entered",[i])
func child_focus_entered(child_idx):
	focus_node_index = child_idx
func _input(event):
	if focus_node_index != -1 and event is InputEventAction and (event as InputEventAction).action == "ui_up":
		set_focus_node_index(get_focus_node_index() + 1)
