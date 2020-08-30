extends "res://scripts/abstracts/generic_enemy.gd"

var mode = "" setget set_mode, get_mode
func set_mode(val):
	#if we move from the attack state to another state reset our target position
	if (val != "Attack" and mode == "Attack"):
		modulate = Color.white
		inner_beat = 0.0
	elif (val == "Attack" and mode != "Attack"):
		modulate = Color.gray
		$Tarantula_Sprite/AnimationPlayer.play("Attack")
	if (val == "Idle" or val == "Alert" or val ==  "Attack_Alert"):
		$Tarantula_Sprite/AnimationPlayer.play("Idle")
	mode = val
func get_mode():
	return mode

#the initial position and rotation of the tarantulas butt
var init_rotation
var init_position
var target_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	$health_bar.hp = 2
	add_to_group("spiders")
	set_mode("Idle")
	init_rotation = $Tarantula_Sprite/Body/Butt.rotation
	init_position = $Tarantula_Sprite/Body/Butt.position
	$NotePlayer.mode = 6
#used to keep track of what musical beat we are on
var inner_beat = 0.0

func on_col(obj,dmg = 1):
	if (mode != "Attack"):
		.on_col(obj,dmg)
#this function ensures that the magnitude of the given vector is 1
func make_dir(v2):
	var n = 1.0/sqrt(v2.x*v2.x+v2.y*v2.y)
	return Vector2(n*v2.x,n*v2.y)

var target_dir = Vector2(0,0)
var speed = 50
func run(player_pos,beat):
	match mode:
		"Attack":
			var collision = move_and_collide(target_dir*speed)
			if (collision):
				if collision.collider.has_method("on_col"):
					collision.collider.on_col(self,2)
					set_mode("Attack_Alert")
			if (position.distance_to(target_pos)) <= 50:
				set_mode("Attack_Alert")
			if (position.distance_to(player_pos) > 500):
				set_mode("Idle")
			match inner_beat:
				0.0:
					$NotePlayer.play_note(1)
				2.0:
					$NotePlayer.play_note(1)
				3.0:
					$NotePlayer.play_note(1)
				4.0:
					$NotePlayer.play_note(1)
				_:
					$NotePlayer.play_note(4)
		"Attack_Alert":
			match inner_beat:
				0.0:
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				0.5:
					$NotePlayer.play_note(2)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation + PI/10
				1.0:
					$NotePlayer.play_note(0)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
				1.5:
					$NotePlayer.play_note(7)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y+10)
				2.0:
					$NotePlayer.play_note(3)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation+PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				_:
					$NotePlayer.stop()
					if (position.distance_to(player_pos) <= 400):
						#the player is in range, attack!
						set_mode("Attack")
						#we want to go twords them
						target_dir = make_dir(player_pos-position)
						#until we are slightly past them
						target_pos = target_dir*2+player_pos
		"Alert":
			#print(mode)
			match inner_beat:
				0.0:
					$NotePlayer.play_note(0)
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y-5)
				0.5:
					$NotePlayer.play_note(7)
					$Tarantula_Sprite/Body/Butt.position = init_position
				1.0:
					$NotePlayer.play_note(4)
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y-5)
				1.5:
					$NotePlayer.play_note(6)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y+10)
					$Tarantula_Sprite/Particles2D.emitting = true
					for node in get_tree().get_nodes_in_group("corruptable"):
						if (position.distance_to(node.position) <= 400):
							node.mode = "evil"
				2.0:
					$NotePlayer.play_note(7)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation+PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				_:
					$NotePlayer.stop()
					if (position.distance_to(player_pos) <= 400):
						#the player is in range, attack!
						set_mode("Attack")
						#we want to go twords them
						target_dir = make_dir(player_pos-position)
						#until we are slightly past them
						target_pos = target_dir*2+player_pos
		"Idle":
			if (position.distance_to(player_pos) < 300):
				set_mode("Alert")
			match inner_beat:
				0.0:
					#print(init_rotation)
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				0.5:
					$NotePlayer.play_note(2)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation + PI/10
				4.0:
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation - PI/10
				2.0:
					$NotePlayer.play_note(1)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation
					$Tarantula_Sprite/Body/Butt.position = Vector2(init_position.x,init_position.y+10)
				3.5:
					$NotePlayer.play_note(2)
					$Tarantula_Sprite/Body/Butt.rotation = init_rotation+PI/10
					$Tarantula_Sprite/Body/Butt.position = init_position
				_:
					$NotePlayer.stop()
	inner_beat += .5
	if (inner_beat == 4.0):
		inner_beat = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
