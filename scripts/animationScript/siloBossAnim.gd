extends Node2D


#this funcction starts the corruption animation
func start_corruption():
	#play the shaking animation
	$siloSpriteAnimation.animation = "Shake"
	$siloSpriteAnimation.playing = true
	#start the node animation player
	$AnimationPlayer.play("Shake")
#syntactic sugar to connect the carrot animation player to a local function
