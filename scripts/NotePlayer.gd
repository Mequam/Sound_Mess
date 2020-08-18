extends AudioStreamPlayer2D
var scale_math = load("res://scripts/abstracts/Scale_Math.gd").new()

#getter and setter to pass through the mode variable
var mode setget set_mode,get_mode
func set_mode(val):
	scale_math.mode = val
func get_mode():
	return scale_math.mode

#loads a note as a resource for our object
func load_note(note_number,note_geter=funcref(scale_math,"note2str")):
	var note = note_geter.call_func(note_number)
	if note[0]:
		#load the octave bellow
		self.stream = load("res://notes/lows/" + note[1] + "_low.wav")
	else:
		#load the main octave
		self.stream = load("res://notes/" + note[1] + ".wav")
	
#this function plays the given scale degree
#TODO: this function name breaks convention established in scale_degree
	#however its quite old and as such is used elsewhere in the code
	#changing the name of this function would require changing it in MANY
	#places
func play_note(scale_degree):
	if (scale_degree == null):
		stop()
	else:
		play_note_index(scale_math.deg2note(scale_degree))
	
func play_note_index(note):
	if (self.playing):
		self.stop()	
	load_note(note)
	self.play()
	
