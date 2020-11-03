extends Node2D
#this code is responcible for the speech bubble player display
var note_color : Color = Color.red
var back_color : Color setget set_back_color,get_back_color
func set_back_color(val):
	$speechBubble.modulate = val
func get_back_color():
	return $speechBubble.modulate
#this is the parent function func syncDisp(notes,mode,score=0,note_dist=scale.x*5):
func dispNote(scale_degree,beat_type,mode):
	$NoteDisplay.syncDisp([[scale_degree,beat_type]],mode)
	$NoteDisplay.setChildrenColor(note_color)
func _ready():
	pass
