
#represents what musical mode to play in
#0 represents Lydian, incriment to get darker through 6
var mode = 0 setget set_mode, get_mode

func get_mode():
	return (mode*2)%7  
func set_mode(setter):
	if (setter % 2 == 0):
		mode = setter/2
	else:
		mode = (setter+7)/2 % 7

#this is the offset that we use to build cords
#these are the distance between white notes on the piano
const offsets = [2,2,2,1,2,2,1]

#an action degree ranges from 0-6
func deg2actionDeg(deg : int):
	return deg+7*int(deg < 0)
#mapps an infinit pitch range into a repeating loop for game control
#basically this takes the whole keyboard and mapps it into loops starting at -7 and ending at 6
func pitch2note(pitch : int)->int:
	return (pitch % 24)-12
func pitch2deg(pitch : int):
	return note2deg(pitch2note(pitch))
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
		tmp_note = -12 #we allways count upwoards when calculating the degree
		tmp_deg = -7 #in this case we change where we go up from
	#test the scale degrees
	for i in range(0,7): #7 is the constant length of offsets
		if (tmp_note == note):
			return tmp_deg
		tmp_note += offsets[(i+mode)%7]
		tmp_deg +=1 
	#the given note is not in the scale
	return null

#syntatic sugar function that returns the name of the action 
#represented by the given degree for outside use
func deg2actionStr(deg):
	while deg < 0:
		deg += 7
	print("creating input string " + "NOTE_" + str(deg))
	return "NOTE_" + str(deg)

#this function takes a mode and a degree, and determines
#if the degree of that mode is the same as the degree of our mode
func degInMode(deg : int,new_mode : int)->bool:
	#cache the intial mode and the deg in that mode
	var initial_mode = mode
	var initial_note = deg2note(deg)
	
	#change our mode for the next calculations
	set_mode(new_mode)
	
	var ret_val = deg2note(deg)==initial_note
	
	#reset the cached mode
	mode = initial_mode
	
	return ret_val
#this function takes a scale degree and throws the appropriate input action
static func deg2action(deg,pressed=true):
	var ie = InputEventAction.new()
	if deg == null:
		ie.action = "WRONG_NOTE"
	else:
		#make sure we re-map to posotive
		while deg < 0:
			deg += 7
		#create and throw the input event
		#we could use the degree to action function here, but this way we
		#avoid a while loop
		ie.action = "NOTE_" + str(deg)
	ie.pressed = pressed
	return ie
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
