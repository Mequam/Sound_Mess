extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	get_node("TreeSprite/AnimationPlayer").play("Singing_Soft")
	get_node("NotePlayer").play_note(note)

func play_soft(note):
	playing = note
	get_node("TreeSprite/AnimationPlayer").play("Singing_Hard")
	get_node("NotePlayer").play_note(note)
func on_col(player):
	if (singing):
		stop()
	singing = !singing
func stop():
	playing = -1
	get_node("TreeSprite/AnimationPlayer").play("Idle")
	get_node("NotePlayer").stop()

var song = []
var beat = 0
var singing = false
#this function is ment to be called incrimentaly on a clock
func run():
	if (singing):
		for note in song:
			if (beat == note[0]):
				if (note[1] == -1):
					stop()
					break
				else:
					play_hard(note[1])
					break
		beat+=1
		if (beat == 4):
			beat = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TreeSprite/AnimationPlayer").play("Idle")
	add_to_group("plants")
	add_to_group("singing_trees")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
