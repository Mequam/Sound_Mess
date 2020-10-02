extends Node

#this script serves as a proxy for the normal AnimationPlayer
#in order to run hooks for given animations
func play(anim):
	if (anim == "Idle"):
		for leaf in get_parent().get_node("leafs").get_children():
			leaf.get_node("AnimationPlayer").play("Idle")
		

