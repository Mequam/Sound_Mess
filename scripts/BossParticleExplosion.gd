extends Node2D
#simple script to remove the particles after they finish emitting

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
