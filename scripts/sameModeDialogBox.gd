extends "res://scripts/practicalDialog.gd"
#this script is for a dialog box that has an in mode and an out mode
#notes that are the same in each node use the first color set
#notes that are different in the two nodes use the second color set

var onColorOut = Color.violet
var offColorOut = Color.gray
var mode : int = 1
var modeOut : int = 2

#wrapper for the syncScoreColor to sync the score with half values
#this is usefull because the combo that the dialog generates
#has two combo actions for every one note, so if we want to connect
#the combo output to a function that syncs the display, we need
#to half the incoming score before syncing

func syncScoreColorDbl(score):
	syncScoreColorRefMode(
		(score/2),
		mode,
		modeOut,
		onColor,
		offColor,
		onColorOut,
		offColorOut
		)

#syntatic sugar function that updates the display with the given mode
func updateDisp(mode,score=0,note_dist=scale.x*7):
	syncDisp(notes,mode,score,note_dist)

#syntatic sugar for getting a combo from a given node
func getCombo(sub_beat):
	return createCombo(notes,sub_beat,name)
