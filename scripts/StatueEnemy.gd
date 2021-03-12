extends "res://scripts/abstracts/corruptable_enemy.gd"
#how fast we move
var speed : float = 900
var movement_dir : Vector2 = Vector2(0,0)
var total_attacks : int = 0 #stores how many attacks we have left
var max_attacks : int = 3 #the total number of attacks we can store
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
		$attack_area.collision_mask = col_math.Layer.PLAYER
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
			if dmg_mv(movement_dir*speed*delta,2):
				set_mode("crouch")
func _on_attack_area_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(2)
