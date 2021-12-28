extends Node2D
#this script spawns the statue enemy and prepares it for animation when the pre centipuide sprite finishes

var centipide_boss = preload("res://scenes/instance/entities/enemies/bosses/bunny/CentipideBoss.tscn")

func animate():
	$AnimationPlayer.play("Transform")
func _on_AnimationPlayer_animation_finished(anim_name):
	var inst = centipide_boss.instance()
	inst.global_position = global_position
	get_parent().add_child(inst)
	queue_free()
