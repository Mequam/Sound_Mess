extends Node
func _ready():
	#get ready to accept midi
	OS.open_midi_inputs()
#this script is a midi input controler that calls functions
#in groups for the given midi input

#part of the reason that we use a sperate node for handling midi inputs is that it likes
#to run on a different thread from the rest of the game

#so a lot of other featers get buggy if we try to interact with things while responding to the midi inputs
#to solve this we run the midi inputs through a system call to get it back to the main thread and also
#to any node that cares about midi 


# via <https://github.com/godotengine/godot/blob/master/core/os/input_event.h>
enum GlobalScope_MidiMessageList {
	MIDI_MESSAGE_NOTE_OFF = 0x8,
	MIDI_MESSAGE_NOTE_ON = 0x9,
	MIDI_MESSAGE_AFTERTOUCH = 0xA,
	MIDI_MESSAGE_CONTROL_CHANGE = 0xB,
	MIDI_MESSAGE_PROGRAM_CHANGE = 0xC,
	MIDI_MESSAGE_CHANNEL_PRESSURE = 0xD,
	MIDI_MESSAGE_PITCH_BEND = 0xE,
};


const MIDI_EVENT_PROPERTIES = ["channel", "message", "pitch", "velocity", "instrument", "pressure", "controller_number", "controller_value"]



func get_midi_message_description(event : InputEventMIDI):
	if GlobalScope_MidiMessageList.values().has(event.message):
		return GlobalScope_MidiMessageList.keys()[event.message - 0x08]
	return event.message


# TODO: Add the black keys.
const OCTAVE_KEY_INDEX = ["WhiteKey1", "BlackKey1", "WhiteKey2", "BlackKey2", "WhiteKey3", "WhiteKey4", "BlackKey3", "WhiteKey5", "BlackKey4", "WhiteKey6", "BlackKey5", "WhiteKey7"]



#determines the type of input that the game is looking for
#options are dev (uses keys 1-7) and midi (uses midi note frequency)
#TODO: this needs a setter and a getter that changes other aspects of the game
#additionaly need to add the fourier transform or "tuner" input method
enum INPUT_MODES {DEV,MIDI}
var input_mode : int = INPUT_MODES.MIDI



#this code is responcible for running all input events in the game
#all of the game runs on one of either two forms of input

#scale degrees: ranging from -7<->6 : control sound and certain combos, derived from modular note pitches
#action degrees: ranging from 0<->6 : control player actions like movement and specials, derived from scale degrees

#action degrees  
#	used to determine things like player movment and actions
#	are computed by the object that recives scale_degrees using the scale math deg2actionDeg function
#	^ in otherwords this input code outputs scale degrees
#scale degrees 
#	are used to play the proper note in responce to midi inputs
#	and for some special cases where we want to use the range 0<->7 instead of 0<->6
#	basically anywhere we need player input wthout strict scale degrees
func _unhandled_input(event : InputEvent):
		if (event is InputEventMIDI):
			match event.message:
				MIDI_MESSAGE_NOTE_ON:
					get_tree().call_group("midi_input","_midi_note_down",event.pitch)
						#respond to a valid scale degree
				MIDI_MESSAGE_NOTE_OFF:
					get_tree().call_group("midi_input","_midi_note_up",event.pitch)
