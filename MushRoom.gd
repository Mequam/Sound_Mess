extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("plants")
	get_node("MushRoomSprite/AnimationPlayer").play("Idle")
	get_node("MushRoomSprite/AnimationPlayer").connect("animation_finished",self,"_anim_finished")
	get_node("NotePlayer").mode = 6
	connect("body_entered",self,"_on_enterd")
func _anim_finished(anim):
	if (anim == "Puff"):
		
		get_node("MushRoomSprite/AnimationPlayer").play("Idle")
func _on_enterd(body):
	playing=true
	get_node("MushRoomSprite/AnimationPlayer").play("Puff")
var inner_beat = 0
#this function is designed to hook up to the met to play notes
var playing = false
func run():
	if (playing):
		if (inner_beat == 2):
			get_node("NotePlayer").play_note(3)
		elif (inner_beat == 3):
			get_node("NotePlayer").stop()
			inner_beat = 0
			playing = false
		inner_beat+=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
