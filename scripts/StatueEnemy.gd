extends "res://scripts/abstracts/corruptable_enemy.gd"


#for when we are not corrupted and the player can use us like a switch
signal completed_dialog

#how fast we move
var speed : float = 900

var movement_dir : Vector2 = Vector2(0,0)

var total_attacks : int = 0 #stores how many attacks we have left

var max_attacks : int = 3 #the total number of attacks we can store

var avatar_statue : int = 1

func set_mode(val : String):
	$NotePlayer.stop()
	if mode == "attack":
		#we are changing from the attack mode into another mode
		#make sure that we are no longer damaging things that enter the spin
		$attack_area.collision_mask = 0
	inner_beat = 0
	if val == "evil":
		$Sprite/AnimationPlayer.play("Idle")
	elif val == "attack":
		#decrease our attack charges
		total_attacks -= 1
		$Sprite/AnimationPlayer.play("Spin")
		
		#set the attack_area collision layer to the enemy collision layer
		$attack_area.collision_mask = col_math.Layer.PLAYER | col_math.Layer.PROJECTILES
	elif val == "crouch":
		$Sprite/AnimationPlayer.play("Crouch_1")
	.set_mode(val)
func can_see(player_pos : Vector2) -> bool:
	return position.distance_squared_to(player_pos) < 1000000
func play_music(inner_beat : int):
	match mode:
		"evil":
			match inner_beat % 8:
				0:
					$NotePlayer.play_note(0)
				2:
					$NotePlayer.play_note(3)
				4:
					$NotePlayer.play_note(4)
				6:
					$NotePlayer.play_note(1)
				_:
					$NotePlayer.stop()
		"crouch":
			match inner_beat % 4:
				0: 
					$NotePlayer.play_note(3)
				1:
					$NotePlayer.play_note(2)
				2:
					$NotePlayer.play_note(1)
				3:
					$NotePlayer.play_note(0)
				_:
					$NotePlayer.stop()
		"attack":
			match inner_beat % 2:
				0:
					$NotePlayer.play_note(4)
				1:
					$NotePlayer.play_note(0)
					
func switch_modes(player_pos : Vector2,inner_beat):
	match mode:
		"crouch":
			if inner_beat >= 4:
				set_mode("attack")
		"attack":
			if not can_see(player_pos) or total_attacks <= 0:
				set_mode("evil")
			elif inner_beat >= 2:
				set_mode("crouch")
		"evil":
			if can_see(player_pos) and inner_beat >= 8:
				total_attacks = max_attacks
				set_mode("crouch")
				
				#temporarily remove collision to protect ourselfs
				#from other enemies this is fixed at the end
				#of our transformation
				#collision_layer = 0
				#collision_mask = 0
func run(player_pos : Vector2,beat):
	switch_modes(player_pos,inner_beat)
	play_music(inner_beat)
	match mode:
		"attack": #actually attack
			movement_dir = (player_pos-position).normalized()
		"evil": #default mode where we look around for the player to attack
			pass
		"crouch": #crouch before attacking
			pass
	inner_beat += 1
	.run(player_pos,beat)
func anim_finished(anim):
	.anim_finished(anim)
func _process(delta):
	match mode:
		"attack":
			var col = dmg_mv(movement_dir*speed*delta,2)
			if col:
				if col.collider.is_in_group("player"):
					set_mode("crouch")
				else:
					set_mode("evil")
func main_ready():
	$health_bar.hp = 2
	.main_ready()
func die():
	#move the statue that we were using back to the main scene
	var statueSwitch = $statueSwitch
	
	#make sure the node cascade effects are maintained
	statueSwitch.position += position
	statueSwitch.scale *= scale
	
	#re-enable the switch
	statueSwitch.enabled = true
	
	#remove it from our tree
	remove_child(statueSwitch)
	
	#add it to the parents
	get_parent().add_child(statueSwitch)
	statueSwitch.get_node("groundPound").emitting = true
	
	.die()
func corrupt():
	#disable the statue switch
	$statueSwitch.enabled = false
	#make sure our sprite knows what is going on
	$Sprite/statue/VariableStatue.display_mode($statueSwitch.statue_mode)
	.corrupt()
func _on_attack_area_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(2)
	elif body.is_in_group("projectile"):
		if body.get_node("Sprite"):
			#look where we are going
			body.get_node("Sprite").rotation_degrees += 180
		body.dir *= -1
		body.collision_mask = collision_mask
		body.modulate = Color.gray
func _on_statueSwitch_completed_dialog(dialog):
	if not is_in_group("enemies"):
		emit_signal("completed_dialog",dialog)
