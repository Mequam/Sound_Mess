extends Node2D


#this funcction starts the corruption animation
func start_corruption():
	#play the shaking animation
	$siloPos/siloSpriteAnimation.playing = true
	play("Shake")
#syntactic sugar to connect the carrot animation player to a local function


func play(anim : String) -> void:
	$AnimationPlayer.play(anim)
	$siloPos/siloSpriteAnimation.play(anim)

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Shake"):
		play("Shake1")
	elif (anim_name == "Shake1"):
		play("Shake2")
	elif (anim_name == "Shake2"):
		play("Shake3")
	elif (anim_name == "Shake3"):
		#the carrot in the middle is.....unpleased with his position
		$MiddleCarrot.play("Monch")
		play("Shake4")
