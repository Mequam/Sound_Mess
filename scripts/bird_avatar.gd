extends "res://scripts/abstracts/avatar.gd"

func play_idle(last_anim : String = "Move_Front") -> void:
	if not get_in_time():
		.play_idle(last_anim)
	else:
		match last_anim:
			"Move_Front":
				$Sprite/AnimationPlayer.play("Fly")
			"Move_Left":
				$Sprite/AnimationPlayer.play("FlyLeft")
			"Move_Back":
				$Sprite/AnimationPlayer.play("FlyBack")
func init():
	.init()
	#2 = mixolidian birds :D
	set_mode(2)
func _ready():
	init()
