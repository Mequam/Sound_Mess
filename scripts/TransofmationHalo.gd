extends Node2D
#generic assets script to make the AnimationPlayer start playing idle
func _ready():
	$AnimationPlayer.play("Idle")
