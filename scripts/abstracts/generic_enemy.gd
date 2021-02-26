extends "res://scripts/abstracts/entity.gd"
#this file is the enemy super class which all enemies
#derive from (save the trapper which is an area 2d)
#TODO: change that ^

#the beat of the enemies song
var inner_beat : int = 0
var initial_sprite_pos : Vector2

#used to keep track of the state that the enemy is in
var mode : String = "default" setget set_mode,get_mode
func set_mode(val)->void:
	mode = val
func get_mode()->String:
	if get_flying():
		return "Flying"
	return mode
#this is an AI switch that is for the bird avatar
#if an enemy is thrown in the air (and should not be) it no longer
#has active AI and flounders around for some beats
#has active AI and flounders around for some beats
var flight_thrown : bool setget set_flying,get_flying
func set_flying(val : bool)->void:
	var fly = get_flying()
	#we should be flying and are not currently
	if val and not fly:
		$Sprite.scale.y *= -1 #they are confused
		$Sprite.position += Vector2(0,-400)
		
		inner_beat = 0 #reset the inner beat for the new "fake mode"
		#stop playing sound if we are playing
		$NotePlayer.stop()
		#let the sprite know that we are thrown
		$Sprite/AnimationPlayer.stop() #incase flightthrown is not implimented
		$Sprite/AnimationPlayer.play("FlightThrown")
		
		#add the shadow
		add_child(load("res://scenes/assets/Shadow.tscn").instance())
		
		#shift our collision into the flight zone
		collision_layer = col_math.shift_collision(gen_col_layer(),col_math.SuperLayer.FLIGHT)
		collision_mask = col_math.shift_collision(gen_col_mask(),col_math.SuperLayer.FLIGHT)
	#we should not be flying
	elif not val:
		#reset the collision to be on the normal layer
		$Sprite.position = initial_sprite_pos
		#flip the sprite back
		$Sprite.scale.y *= -1
		
		#remove the shadow
		if $Shadow:
			$Shadow.queue_free()

		#reset our collision
		collision_layer = gen_col_layer()
		collision_mask = gen_col_mask()
		
		#this is a neat trick to re-set the animation of the enemy
		#by setting the mode of the enemy to itself, we
		#cause whatever animation setup happened BEFORE the get_mode
		#to fire again
		set_mode(get_mode())

func get_flying()->bool:
	#returns true if we are shifted into the flight layer
	return col_math.in_layer_no_constants(
		collision_layer,
		col_math.shift_collision(gen_col_layer(),col_math.SuperLayer.FLIGHT))
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
	add_to_group("kinematicEnemies")
	#if they have a sprite node, connect the animation on it
	if (get_node("Sprite")):
		$Sprite/AnimationPlayer.connect("animation_finished",self,"anim_finished")
		initial_sprite_pos = $Sprite.position
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
#called every beat with the players position for processing inteanded
#to be overloaded by children
func run(player_pos,beat)->void:
	pass
#this function is ACTUALLY called every beat
#and is not inteanded to be overiden by the child
#the idea is that this wrapps child behavior so we can susptitue
#any child AI for our own AI on a whim
func run_wrapper(player_pos,beat)->void:
	if get_flying():
		inner_beat += 1
		#fall out of flight
		if inner_beat >= 16:
			set_flying(false)
	else:
		run(player_pos,beat)
