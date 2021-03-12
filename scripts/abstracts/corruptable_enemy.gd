extends "res://scripts/abstracts/generic_enemy.gd"

#we collide with nothing as we do not start corrupted
func gen_col_layer()->int:
	return 0
func gen_col_mask()->int:
	return 0

func set_flying(val : bool)->void:
	.set_flying(val)
	if val:
		#we use the parents collision not ours when shifting flight
		collision_layer = col_math.shift_collision(.gen_col_layer(),col_math.SuperLayer.FLIGHT)
		collision_mask = col_math.shift_collision(.gen_col_mask(),col_math.SuperLayer.FLIGHT)
	else:
		collision_layer = .gen_col_layer()
		collision_mask = .gen_col_mask()
#note that we need to use the parent collision for this
func get_flying()->bool:
	#returns true if we are shifted into the flight layer
	return col_math.in_layer_no_constants(
		collision_layer,
		col_math.shift_collision(.gen_col_layer(),col_math.SuperLayer.FLIGHT))

func run_wrapper(run,pos):
	.run_wrapper(run,pos)

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
