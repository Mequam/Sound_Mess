extends "res://scripts/abstracts/generic_enemy.gd"

#this is the function that causes us to get corrupted
func corrupt():
	get_node("Sprite/AnimationPlayer").play("Transform")
	remove_from_group("corruptable")
	set_mode("still")
func _ready():
	remove_from_group("enemies")
	add_to_group("corruptable")

#overload the parent behavior to save our state on death
#corruptable enemys do not save when they die
func die()->void:
	emit_signal("die",self)
	queue_free()

func anim_finished(anim):
	#if we finish transforming we are now EVIIIIL mwhahahaha
	if (anim == "Transform"):
		add_to_group("enemies")
		set_mode("evil")
