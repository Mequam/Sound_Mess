extends "res://scripts/generic_enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#represents the mode that the spdider is in, search, patroll, attack
var mode = "search" setget set_mode,get_mode
var just_attacked = false

func on_col(player,dmg=1):
	if (player.is_in_group("player") and player.i_timer != null and player.i_timer > 0):
		$health_bar.hp -= dmg
	elif (!player.is_in_group("player")):
		$health_bar.hp -= dmg
	if ($health_bar.hp <= 0):
		set_mode("die")
func set_mode(val):
	#print("[SPIDER] changing mode:" + mode)
	if (val in ["die","search","patroll","attack"] and mode != "die"): #once we die we dont change modes
		if (val == "die"):
			if (mode == "attack"):
					$NotePlayer.volume_db += 3
					mode = "die"
					#we are diying now is not the time for collisions!
					collision_layer = 0
					collision_mask = 0
		else:
			if (mode =="attack"):
				just_attacked = true
			if val == "attack" and mode != "attack":
				get_node("NotePlayer").volume_db /= 2
			elif (val != "attack" and mode == "attack"):
				get_node("NotePlayer").volume_db *= 2
		mode = val
		play_modal_animation(mode)

func get_mode():
	return mode

var patroll_down = true
var speed = 15
# Called when thenode enters the scene tree for the first time.
func _ready():
	$health_bar.hp = 2
	add_to_group("enemies")
	add_to_group("spiders")
	get_node("NotePlayer").mode = 4
	get_node("Spider/AnimationPlayer").play("Idle")
func play_modal_animation(mode):
	match mode:
		"die" :
			get_node("Spider").scale.y *= -1
			get_node("Spider/AnimationPlayer").play("Scury")
		"search" :
			get_node("Spider/AnimationPlayer").play("Idle")
		"patroll" :
			get_node("Spider/AnimationPlayer").play("Scury")
		"attack" :
			get_node("Spider/AnimationPlayer").play("Scury")
#returns true if we can see the target
func can_see(target_pos):
	#print(str(target_pos.y-10) + ',' + str(target_pos.y+10) + ':' + str(position.y))
	return position.distance_to(target_pos) <= 1000 and target_pos.y-position.y <= 20*scale.y and target_pos.y-position.y >= -20*scale.y  
#makes the spider look for a target and change modes accordingly
func look(target_pos):
	#print("[SPIDER] looking!")
	if (can_see(target_pos)):
		set_mode("attack")

var _just_offscreen = false

var look_cycle_a = true

var _death_beat = 1.0
#plays the proper note for the given beat
func play_note(beat):
	match mode:
		"die":
			#our death song plays no matter what beat we start on
			match _death_beat:
				1.0:
					get_node("Spider").anim_look_top_right()
					get_node("Spider").anim_look_bottom_right()
					get_node("NotePlayer").play_note(1)
				1.5:
					get_node("Spider").anim_look_top_left()
					get_node("Spider").anim_look_bottom_left()
					get_node("NotePlayer").play_note(2)
				2.0:
					get_node("Spider").anim_look_top_right()
					get_node("Spider").anim_look_bottom_right()
					get_node("NotePlayer").play_note(1)
				2.5:
					get_node("Spider").anim_look_top_left()
					get_node("Spider").anim_look_bottom_left()
					get_node("NotePlayer").play_note(2)
				3.0:
					get_node("NotePlayer").play_note(0)
				4.0:
					queue_free()
			_death_beat+=.5
		"patroll":
			match beat:
				1.0:
					if (look_cycle_a):
						get_node("Spider").anim_look_top_left()
					else:
						get_node("Spider").anim_look_top_right()
					get_node("NotePlayer").play_note(1)
				2.0:
					if (look_cycle_a):
						get_node("Spider").anim_look_bottom_right()
					else:
						get_node("Spider").anim_look_bottom_left()
					get_node("NotePlayer").play_note(4)
				3.0:
					get_node("Spider").anim_look_center()
					look_cycle_a = !look_cycle_a
					get_node("NotePlayer").play_note(1)
				4.0:
					get_node("NotePlayer").stop()
		"attack":
			match beat:
				1.0:
					if (look_cycle_a):
						get_node("Spider").anim_look_top_left()
					else:
						get_node("Spider").anim_look_top_right()
					get_node("NotePlayer").play_note(1)
				1.5:
					if (look_cycle_a):
						get_node("Spider").anim_look_bottom_right()
					else:
						get_node("Spider").anim_look_bottom_left()
					get_node("NotePlayer").play_note(2)
				2.0:
					get_node("Spider").anim_look_center()
					look_cycle_a = !look_cycle_a
					get_node("NotePlayer").play_note(1)
				2.5:
					get_node("NotePlayer").stop()
				3.0:
					if (look_cycle_a):
						get_node("Spider").anim_look_top_left()
					else:
						get_node("Spider").anim_look_top_right()
					get_node("NotePlayer").play_note(1)
				3.5:
					if (look_cycle_a):
						get_node("Spider").anim_look_bottom_right()
					else:
						get_node("Spider").anim_look_bottom_left()
					get_node("NotePlayer").play_note(2)
				4.0:
					get_node("Spider").anim_look_center()
					look_cycle_a = !look_cycle_a
					get_node("NotePlayer").play_note(1)
				4.5:
					get_node("NotePlayer").stop()
		"search":
			match beat:
				1.0:
					if (look_cycle_a):
						get_node("Spider").anim_look_top_left()
					else:
						get_node("Spider").anim_look_top_right()
					get_node("NotePlayer").play_note(1)
				2.0:
					if (look_cycle_a):
						get_node("Spider").anim_look_bottom_right()
					else:
						get_node("Spider").anim_look_bottom_left()
					get_node("NotePlayer").play_note(4)
				3.0:
					get_node("Spider").anim_look_center()
					look_cycle_a = !look_cycle_a
					get_node("NotePlayer").play_note(1)
				4.0:
					get_node("NotePlayer").stop()

func move_dir(dir,mod=1):
	var col = move_and_collide(dir*speed*mod)
	if (col):
		if (col.collider.has_method("on_col")):
			col.collider.on_col(self,1)
		patroll_down = !patroll_down
		

#this is used as a timer to tell how long we are vulnerable to the spider song after attacking
var attack_cool_down_max = 32
var attack_cool_down_timer = attack_cool_down_max

#calling this function causes the spider to update its state
func run(target_pos,beat):
	match mode:
		"search":
			look(target_pos)
		"patroll":
			var dir
			if (patroll_down):
				dir = Vector2(0,-1)
			else:
				dir = Vector2(0,1)
			move_dir(dir)
			if (!get_node("VisibilityNotifier2D").is_on_screen() and !_just_offscreen):
				patroll_down = !patroll_down
				_just_offscreen = true
			elif (get_node("VisibilityNotifier2D").is_on_screen()):
				_just_offscreen = false
			
			look(target_pos)
		"attack":
			var dir
			if (target_pos.x < position.x):
				dir = Vector2(-1,0)
			else:
				dir = Vector2(1,0)
			move_dir(dir,2)
			if (!can_see(target_pos)):
				set_mode("patroll")
	attack_cool_down_timer -= 1
	if (attack_cool_down_timer == 0):
		just_attacked = false
		attack_cool_down_timer = attack_cool_down_max
	play_note(beat)
