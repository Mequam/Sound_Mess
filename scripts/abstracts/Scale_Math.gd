
#represents what musical mode to play in
#0 represents Lydian, incriment to get darker through 6
var mode = 0 setget set_mode, get_mode

func get_mode():
	return (mode*2)%7  
func set_mode(setter):
	if (setter % 2 == 0):
		mode = setter/2
	else:
		mode = (setter+7)/2 %7

#this is the offset that we use to build cords
const offsets = [2,2,2,1,2,2,1]

#this function takes a note number and returns the string name of the note
#note: to get the note numbers start on zero and add .f for each note
func note2str(note_number):
	var low = note_number < 0
	if low:
		note_number += 12
	if (note_number >= 0 and note_number < 12):
		return [low,
				(['c','c#','d','d#','e','f','f#','g','g#','a','a#','b'])[note_number]]
	else:
		return [false,'c']
func note2deg(note):
	var tmp_note = 0
	var tmp_deg = 0
	#account for the negative
	if (note < 0):
		tmp_note = -12
		tmp_deg = -7
	#test the scale degrees
	for i in range(0,7): #7 is the constant length of offsets
		if (tmp_note == note):
			return tmp_deg
		tmp_note += offsets[(i+mode)%7]
		tmp_deg +=1 
	#the given note is not in the scale
	return null

#this function takes a scale degree and throws the appropriate input action
func deg2action(deg):
	#make sure we re-map to posotive
	while deg < 0:
		deg += 7
	#create and throw the input event
	var ie = InputEventAction.new()
	ie.action = "NOTE_" + str(deg)
	ie.pressed = true
	Input.parse_input_event(ie)
#this function takes a scale degree and returns a note index
func deg2note(scale_degree):
	var to_play = 0
	if (scale_degree < 7):
		#re-map to a scale degree we can use
		scale_degree += 7
		#make sure to account for the negative note in the calculation
		to_play = -12

	#build the note to play from the offsets of our given scale (add the offsets until we get the actual note value)
	for i in range(0,scale_degree):
		to_play += offsets[(i+mode)%7]
	
	return to_play
