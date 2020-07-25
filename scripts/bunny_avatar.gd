extends "res://scripts/avatar.gd"
var running_7
func run_seven(to_move,delta):
	running_7 = true
	return 2
func ground_pound():
	pass
func anim_finished(anim):
	if (running_7):
		running_7 = false
		$Sprite/AnimationPlayer.play("Ground_Pound")
	elif (anim == "Ground_Pound"):
		ground_pound()
		#go back to our idle state
		$Sprite/AnimationPlayer.play("Idle")
	else:
		.anim_finished(anim)
func _ready():
	._ready()

func dir_anim(dir,prefix=""):
	if (running_7):
		.dir_anim(dir,"High_")
	else:
		.dir_anim(dir)
