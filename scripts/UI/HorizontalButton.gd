extends Control

#this script runs the animation player in the custom horizontal button


func _on_AnimatedTriangleButton_focus_entered():
	print("focus entered")
	$TextureButton/AnimationPlayer.play("focus_entered")

func _on_AnimatedTriangleButton_focus_exited():
	print("focus exited")
	$TextureButton/AnimationPlayer.play_backwards("focus_entered")
