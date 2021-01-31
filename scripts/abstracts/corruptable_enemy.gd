extends "res://scripts/abstracts/generic_enemy.gd"

#we collide with nothing as we do not start corrupted
func gen_col_layer()->int:
	return 0
func gen_col_mask()->int:
	return 0

#this is the function that causes us to get corrupted
func corrupt():
	get_node("Sprite/AnimationPlayer").play("Transform")
	remove_from_group("corruptable")
	set_mode("still")
	
func main_ready():
	.main_ready()
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
		#make sure the health bar is visible
		$health_bar.sync_disp()
		#move our collision to the enemy collision
		collision_layer = .gen_col_layer()
		collision_mask = .gen_col_mask()
