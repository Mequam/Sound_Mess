extends "res://scripts/abstracts/generic_enemy.gd"

func set_mode(val):
	resetEyeSize()
	inner_beat = 0.0
	#if we move from the attack state to another state reset our target position
	if (val != "Attack" and mode == "Attack"):
		modulate = Color.white
	elif (val == "Attack" and mode != "Attack"):
		#make the visual changes for the given mode
		modulate = Color.gray
		$Tarantula_Sprite/AnimationPlayer.play("Attack")
	if (val == "Idle" or val == "Alert" or val ==  "Attack_Alert"):
		$Tarantula_Sprite/AnimationPlayer.play("Idle")
	mode = val

#the initial position and rotation of the tarantulas butt
var init_rotation
var init_position
var init_eye_scale = []
var target_pos

# Called when the node enters the scene tree for the first time.
func main_ready()->void:
	#we are a spider after all
	add_to_group("spiders")
	#used to keep track of what musical beat we are on
	inner_beat = 0
	$health_bar.hp = 2
	#we start off looking for somthing to EAT
	set_mode("Idle")
	#store the default state for the animated transformations
	init_rotation = $Tarantula_Sprite/Body/Butt.rotation
	init_position = $Tarantula_Sprite/Body/Butt.position
	for eye in $Tarantula_Sprite/Body/Head/eyes.get_children():
		init_eye_scale.append(eye.scale) 
	.main_ready()
	
#simple display function that multiplies the size of our eyes
func multEyeSize(factor):
	for node in $Tarantula_Sprite/Body/Head/eyes.get_children():
		node.scale *= factor
#this function resets the eye size to initial scale
func resetEyeSize():
	var children = $Tarantula_Sprite/Body/Head/eyes.get_children()
	for i in range(0,len(init_eye_scale)):
		children[i] = init_eye_scale[i]
func on_col(obj,dmg = 1):
	if (mode != "Attack"):
		.on_col(obj,dmg)
var target_dir = Vector2(0,0)
var speed = 50
func run(player_pos,beat):
	match mode:
		"Attack":
			var collision = move_and_collide(target_dir*speed)
			if (collision):
				if collision.collider.has_method("on_col"):
					collision.collider.on_col(self,2)
					#we hit the player, get a new target point
					set_mode("Attack_Alert")
			#we are close to the player, get a new target point
			if (position.distance_to(target_pos)) <= 50:
				set_mode("Attack_Alert")
			if (position.distance_to(player_pos) > 500):
				set_mode("Idle")
				
			#play notes corisponding to our attack animation
			match inner_beat:
				0:
					$NotePlayer.play_note(1)
				4:
					$NotePlayer.play_note(1)
				6:
					$NotePlayer.play_note(1)
				8:
					$NotePlayer.play_note(1)
				_:
					$NotePlayer.play_note(4)
		"Attack_Alert":
			match inner_beat:
				0:
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				1:
					$NotePlayer.play_note(2)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation + PI/10
				2:
					$NotePlayer.play_note(0)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
				3:
					$NotePlayer.play_note(7)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y+10)
				4:
					$NotePlayer.play_note(3)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation+PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				5:
					#make the eyes bigger for the last beat, indicating attack
					multEyeSize(2.5)
					$NotePlayer.stop()
				6:
					resetEyeSize()
					$NotePlayer.play_note(4)
				_:
					$NotePlayer.stop()
					if (position.distance_to(player_pos) <= 400):
						#the player is in range, attack!
						set_mode("Attack")
						#we want to go twords them
						target_dir = (player_pos-position).normalized()
						#until we are slightly past them
						target_pos = target_dir*2+player_pos
		"Alert":
			match inner_beat:
				0:
					$NotePlayer.play_note(0)
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y-5)
				1:
					$NotePlayer.play_note(7)
					$Tarantula_Sprite/Body/Butt.position = init_position
				2:
					$NotePlayer.play_note(4)
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y-5)
				3:
					$NotePlayer.play_note(6)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y+10)
					$Tarantula_Sprite/Particles2D.emitting = true
					for node in get_tree().get_nodes_in_group("corruptable"):
						if (position.distance_to(node.position) <= 400):
							node.corrupt()
				4:
					$NotePlayer.play_note(7)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation+PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				_:
					$NotePlayer.stop()
					if (position.distance_to(player_pos) <= 400):
						#the player is in range, attack!
						set_mode("Attack")
						#we want to go twords them
						target_dir = (player_pos-position).normalized()
						#until we are slightly past them
						target_pos = target_dir*2+player_pos
		"Idle":
			if (position.distance_squared_to(player_pos) < 90000):
				set_mode("Alert")
			match inner_beat:
				0:
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				1:
					$NotePlayer.play_note(2)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation + PI/10
				8:
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
				4:
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y+10)
				7:
					$NotePlayer.play_note(2)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation+PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				_:
					$NotePlayer.stop()
	inner_beat += 1
	if (inner_beat == 8.0):
		inner_beat = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
