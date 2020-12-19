extends Node2D
#this script automates the note player
#to play programable songs much like a jute box

var music_mode setget set_mode,get_mode

#this variable stores the note that we are currently playing
var playing = -1 setget set_playing,get_playing

func get_playing():
	return playing
	
func set_playing(value):
	if (value == -1):
		stop()
	else:
		play_soft(value)

func get_mode():
	return get_node("NotePlayer").mode
func set_mode(music_mode):
	get_node("NotePlayer").mode = music_mode
	
func play_hard(note):
	playing = note
	get_node("Sprite/AnimationPlayer").play("Singing_Hard")
	get_node("NotePlayer").play_note(note)

func play_soft(note):
	playing = note
	get_node("Sprite/AnimationPlayer").play("Singing_Soft")
	get_node("NotePlayer").play_note(note)

func stop():
	playing = -1
	get_node("Sprite/AnimationPlayer").play("Idle")
	get_node("NotePlayer").stop()

#the song to sing, the first number is the beat that we sing
#the second number is the note
var song = [] setget set_song,get_song
func set_song(val):
	song = val
	song_length = len(song)
func get_song():
	return song

#the beat that we are on
var elapsed_beat = 0
#the note that we are focused on
var idx : int = 0
#weather or not we are singing
var singing = false
#the beat that we loop around on
var max_beat = -1
#the leangth of our song, set in ready
var song_length : int = 0

#this function is ment to be called incrimentaly on a clock
func run():
	if (singing):
		elapsed_beat+=1
		if (idx < song_length and song[idx][0] == elapsed_beat):
			if (song[idx][1] == null):
				stop()
			else:
				play_hard(song[idx][1])
			idx+=1
		if (elapsed_beat == max_beat):
			elapsed_beat = 0
			idx = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite/AnimationPlayer").play("Idle")
	add_to_group("jutebox")
	if (len(song) > 0):
		max_beat = song[len(song)-1][0]
