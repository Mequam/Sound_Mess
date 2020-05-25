extends AudioStreamPlayer2D


#represents what musical mode to play in
#0 represents Lydian, incriment to get darker through 6
var mode setget set_mode, get_mode
var index = 0

func get_mode():
	return (index*2)%7  
func set_mode(setter):
	if (setter % 2 == 0):
		index = setter/2
	else:
		index = (setter+7)/2 %7
	print('[DEBUG] set index to ' + str(index))

#this is the offset that we use to build cords
var offsets = [1,1,1,.5,1,1,.5]

#this function takes a note number and returns the note name
#note: to get the note numbers start on zero and add .f for each note
func get_note(note_number):
	var letters = ['c','c#','d','d#','e','f','f#','g','g#','a','a#','b']
	if (note_number/.5 >= 0 and note_number/.5 < 12):
		return letters[note_number/.5]
	else:
		#default case
		return 'c'

#loads a note as a resource for our object
func load_note(note_number):
	var st = load("res://notes/" + get_note(note_number) + ".wav")
	self.stream = st

#this function plays the given scale degree
func play_note(scale_degree):
	var to_play = 0
	for i in range(0,scale_degree):
		to_play += offsets[(i+index)%7]
	
	#stop playing to load the note
	if (self.playing):
		self.stop()
		
	load_note(to_play)
	
	self.play()

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
