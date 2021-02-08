extends "res://scripts/abstracts/entity.gd"
#this file is the enemy super class which all enemies
#derive from (save the trapper which is an area 2d)
#TODO: change that ^

#the beat of the enemies song
var inner_beat : int = 0

#used to keep track of the state that the enemy is in
var mode : String = "default" setget set_mode,get_mode
func set_mode(val)->void:
	mode = val
func get_mode()->String:
	return mode

#these functions generate the collision layer that every
#enemy is part of by default
func gen_col_layer()->int:
	return (.gen_col_layer() | 
			col_math.ConstLayer.ALL_ENEMIES | 
			col_math.Layer.ENEMY)
func gen_col_mask() -> int:
	return (.gen_col_mask() | 
			col_math.Layer.PLAYER | 
			col_math.Layer.TERRAIN)
#generic enemy ready function
func main_ready()->void:
	add_to_group("enemies")
	#if they have a sprite node, connect the animation on it
	if (get_node("Sprite")):
		$Sprite/AnimationPlayer.connect("animation_finished",self,"anim_finished")
	
	$save_state_node.load_data()
	
	#set the note player up properly
	$NotePlayer.bus = "generic_enemy"
	$NotePlayer.mode = 6
	
	#call the parent ready
	.main_ready()

#moves in a direction and damages anything we come accross
func dmg_mv(dir,dmg) -> CollisionObject:
	var col = move_and_collide(dir)
	if (col and col.collider.has_method("on_col")):
		#damage the collider
		col.collider.on_col(self,dmg)
	return col
func die()->void:
	$save_state_node.save_death()
	.die()
#virtual functions

#called when the animation player finishes its animation,
#used for syncing visual actions with the auditory notes and 
#damaging abilities
func anim_finished(anim)->void:
	pass
#called every beat with the players position for processing
func run(player_pos,beat)->void:
	pass
