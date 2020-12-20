extends Node2D


func _ready():
	#start the idle animation
	$AnimationPlayer.play("Idle")
