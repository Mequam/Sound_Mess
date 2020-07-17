extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("NotePlayer").mode = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(0,8):
		if (Input.is_action_just_pressed("NOTE_" + str(i))):
			print("playing scale index:" + str(i-7))
			get_node("NotePlayer").play_note(i-7)
