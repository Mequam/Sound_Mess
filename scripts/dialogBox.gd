extends Node2D
#this contains the scale math functions that we need to decode the 
var scale_math = load("res://scripts/abstracts/Scale_Math.gd").new()

signal player_said

#clears the display
func clearDisp():
	for note in get_children():
		if note.name != "ComboTracker":
			note.queue_free()

#this is an internal function that adds the given note to the given
#combo container
func addNewAction(note,sub_beat,combo):
	print("using a sub beat of " + str(sub_beat))
	var actName = scale_math.deg2actionStr(note[0])
	combo.addNewComboAction(
			actName, #str action name
			false,# action up?
			sub_beat*note[1]) #action delta
	combo.addNewComboAction(
			actName, #str action name
			true,# action up?
			0.15) #action delta
						
#this function takes a set of notes and returns a valid combo object
func createCombo(notes,sub_beat,name="dialog"):	
	#get a combo container
	var combo = load("res://scripts/combo_container.gd").new()
	combo.action_list = []
	#add the actions to that combo container
	for note in notes:
		addNewAction(note,sub_beat,combo)
	#the delta for the first action has to be zero
	combo.action_list[0].delta = 0
	#set the combo name
	combo.name = name
	
	#return the combo
	return combo

#sets the color modulation of all children
func setChildrenColor(c : Color):
	for child in get_children():
		child.modulate = c
#this function syncs the color of our notes with a given score
#WITHOUT re-drawing all of the notes 
func syncScoreColor(score,onColor=Color.orangered,offColor=Color.white):
	#clear the color of each note
	setChildrenColor(offColor)
		
	#set the desired notes to the given color
	for i in range(0,score):
		var child = get_child(i)
		#edge case to check array index
		if (not child):
			#if the child is invalid, we have finished coloring
			break
		get_child(i).modulate = onColor
#this fuction displays the given note array as dialog in the node
func syncDisp(notes,mode,score=0,note_dist=scale.x*5):
	clearDisp()
	
	#sync the mode that we are using
	scale_math.mode = mode
	
	#how far to the right that we spawn notes
	var offset_pos = Vector2(0,0)
	
	#the notes that we are going to spawn
	var quarter = load("res://scenes/assets/quarter_note_sprite.tscn")
	var eigth = load("res://scenes/assets/eigth_note_sprite.tscn")

	for note in notes:
		#add the note to the scene
		var to_add
		match note[1]:
			1:
				to_add = eigth.instance()
			2:
				to_add = quarter.instance()
		
		if score != 0:
			to_add.modulate = Color.rebeccapurple
			score -= 1
		#add the children so that they can complete their ready function
		add_child(to_add)
		
		#make the note match its display degree
		to_add.display_degree = note[0]
		
		#set the y value for the actual note of the scale degree
		#the computer chord space is oposite normal notes
		offset_pos.y = -scale_math.deg2note(note[0])*scale.y
		
		#change the position of the note
		to_add.position += offset_pos
		
		#the next note will be placed more to the right
		offset_pos.x += note_dist
