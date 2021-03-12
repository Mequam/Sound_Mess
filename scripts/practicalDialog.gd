extends "res://scripts/dialogBox.gd"
#this script is inteanded to be a version of a dialogBox, but one 
#that remembers and holds the state of notes that it is supposed to use

#this is an array of an array of two integers, the first represents
#the note to be played (scale degree) the second represents the actual note 
#length: 1 eith 2 quarter
var notes = [[-7,1]]
var onColor = Color.orangered
var offColor = Color.white

#wrapper for the syncScoreColor to sync the score with half values
#this is usefull because the combo that the dialog generates
#has two combo actions for every one note, so if we want to connect
#the combo output to a function that syncs the display, we need
#to half the incoming score before syncing
func syncScoreColorDbl(score):
	syncScoreColor(score/2,onColor,offColor)

#syntatic sugar function that updates the display with the given mode
func updateDisp(mode,score=0,note_dist=scale.x*60):
	syncDisp(notes,mode,score,note_dist)

#syntatic sugar for getting a combo from a given node
func getCombo(sub_beat):
	return createCombo(notes,sub_beat,name)
