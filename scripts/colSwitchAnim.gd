extends "res://scripts/colSwitch.gd"
#reference to the animation player that we puppet
var animPlayer : Node

#this utilizes the animation player of the parent to change parent appearence 
func _ready():
	#store the reference to the animation player of the parent
	animPlayer = get_parent().get_node("AnimationPlayer")
	#if the parent has an animation player, set up the
	if (animPlayer):
		connect("state_changed",self,"_state_changed") 
func _state_changed(state : bool):
	if (on):
		animPlayer.play("on_anim")
	else:
		animPlayer.play("off_anim")
