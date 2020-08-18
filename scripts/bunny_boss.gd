extends KinematicBody2D

var scale_math = load("res://scripts/abstracts/Scale_Math.gd").new()
var init_col_layer
var init_col_mask
func _ready():
	init_col_layer = collision_layer
	init_col_mask = collision_mask
	$health_bar.hp = 20
	scale_math.mode = 6
	add_to_group("spiders")
	add_to_group("enemies")
	$NotePlayer.mode = 6
	$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Top")
	set_mode("move_circle")

var inner_beat = 0
var dieing_burrow_particle = load("res://scenes/instance/dieing_particle.tscn")
var mode = "move_circle" setget set_mode,get_mode
func set_mode(val):
	if (mode == "move_slam"):
		collision_layer = init_col_layer
		collision_mask = init_col_mask
	inner_beat = 0
	mode = val
	moving = mode.split("_")[0] == "move"
	match mode:
		"move_burrow":
			$Bunny_Boss_Sprite/AnimationPlayer2.play("Burrow")
func get_mode():
	return mode

var moving = false
var burrow_radius = 1000
var burrow_speed = 200
var burrow_target_point : Vector2
func dir_anim(dir,x_wieght=1):
	if (float(x_wieght*abs(dir.x)) > float(abs(dir.y))):
		if (dir.x > 0 and $Bunny_Boss_Sprite.scale.x > 0):
			$Bunny_Boss_Sprite.scale.x *= -1
		elif (dir.x < 0 and $Bunny_Boss_Sprite.scale.x < 0):
			$Bunny_Boss_Sprite.scale.x *= -1
		$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Side")
	elif (dir.y > 0):
		$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Top")
	else:
		$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Back")
func get_ctx_matrix(player_pos):
	var local = player_pos-position
	var m = Transform2D()
	#the direction we are aiming
	m.x = local.normalized()
	#this is a fancy way of rotating 90 degrees counter clockwise with matrixes
	m.y = Vector2(local.y*-1,local.x).normalized()
	return m
var burrow_dir
func move(player_pos,inner_beat):
	print("movement inner beat " + str(inner_beat))
	match mode:
		"move_burrow":
			if (inner_beat == 1):
				var theta = (randf()*PI/2)+PI/4
				print(burrow_radius*Vector2(cos(theta),sin(theta)) + Vector2(position.distance_to(player_pos),0))
				burrow_dir = (burrow_radius*Vector2(cos(theta),sin(theta)) + Vector2(position.distance_to(player_pos),0)).normalized()
			if (inner_beat >= 1 and inner_beat <= 8):
				if (burrow_dir != null):
					var m = get_ctx_matrix(player_pos)
					#select a random point on a circle of radius burrow_radius 
					#then move that point over the player in target space (where the player is on the x axis)
						
					#now create a vector of length burrow speed and point to that point
					var col = move_and_collide(
						m.xform(
							burrow_dir*burrow_speed
							)
						)
					if !col:
						var part_div = burrow_speed/4
						for i in range(0,4):
							var part = dieing_burrow_particle.instance()
							part.position = position+m.xform(-i*part_div*burrow_dir)
							get_tree().get_root().add_child(part)
			if(inner_beat == 9):
				burrow_dir = (player_pos-position).normalized()*burrow_speed
			if (inner_beat >= 9 and inner_beat%3==0):
				move_and_collide(
					burrow_dir
						)
				var part_dir = burrow_dir/4
				for i in range(0,4):
					var part = dieing_burrow_particle.instance()
					part.position = position-(i*part_dir)
					get_tree().get_root().add_child(part)
			return 16
		"move_circle":
			var m = get_ctx_matrix(player_pos)
			
			var dir
			match (inner_beat-1):
				1:
					dir = m.basis_xform(Vector2(50,200))
				3:
					dir = m.basis_xform(Vector2(100,100))
				5:
					dir = m.basis_xform(Vector2(50,50))
			if (dir != null):
				move_and_collide(dir)
				dir_anim(-m.basis_xform(Vector2(0,1)),.6)
			return 6
		"move_strike":
			match inner_beat:
				1:
					#TODO: this needs to be a function I have used it three times now
					var part_dir = (player_pos-position).normalized()*40
					for i in range(0,4):
						var part = dieing_burrow_particle.instance()
						part.position = position-(i*part_dir)
						get_tree().get_root().add_child(part)
						
					position = player_pos + Vector2(0,-100)
				2:
					$Bunny_Boss_Sprite/AnimationPlayer2.play("Front_Slash_Windup")
				4:
					$Bunny_Boss_Sprite/AnimationPlayer2.play("Front_Slash")
			return 5
		"move_slam":
			print("running move_slam with a beat of " + str(inner_beat) + " " + str(collision_layer))
			match inner_beat:
				2:
					collision_mask = 0
					collision_layer = 0
					position = player_pos
					$Bunny_Boss_Sprite/AnimationPlayer2.play("Front_Slash_Windup")
			return 10
func play_beats(mode):
	match mode:
		"move_circle":
			match (inner_beat-1):
					0:
						$Bunny_Boss_Sprite/AnimationPlayer.play("left_leg_out")
						$NotePlayer.play_note(-7)
					1:
						$Bunny_Boss_Sprite/AnimationPlayer.play("Idle")
						$NotePlayer.play_note(-5)
						
					2:
						$Bunny_Boss_Sprite/AnimationPlayer.play("mid_leg_out")
						$NotePlayer.play_note(-3)
					3:
						$Bunny_Boss_Sprite/AnimationPlayer.play("Idle")
						$NotePlayer.play_note(-6)
					4:
						$Bunny_Boss_Sprite/AnimationPlayer.play("right_leg_out")
						$NotePlayer.play_note(-4)
					5:
						$Bunny_Boss_Sprite/AnimationPlayer.play("Idle")
						$NotePlayer.play_note(-6)
					_:
						$NotePlayer.stop()
		"move_burrow":
			$NotePlayer.play_note(([0,2,3,2,0,2,3,2
						,4,2,0,4,2,0,4,0])[inner_beat-1])
		"move_strike":
			$NotePlayer.play_note([-7,-4,null,1,-7][inner_beat-1])
		"move_slam":
			if ((inner_beat-2) >= 0 and inner_beat < 9):
				$NotePlayer.play_note([0,-2,-4,-3,-4,-5,-7][inner_beat-2])
			return 10
var mode_repeats = 0
func update_mode(mode,repeats):
	match int(rand_range(0,3)):
		0:
			set_mode("move_circle")
		1:
			set_mode("move_burrow")
		2:
			set_mode("move_slam")
		_:
			set_mode("move_circle")
	#match mode:
	#	"move_circle":
	#		if (repeats >= 2):
	#			set_mode("move_slam")
	#			return 0
	#	"move_burrow":
	#		set_mode("move_circle")
	#	"move_slam":
	#		set_mode("move_circle")
	return repeats+1
func run(player_pos,beat):
	if (moving):
		play_beats(mode)
		if (inner_beat >= move(player_pos,inner_beat)):
			inner_beat = 0
			mode_repeats = update_mode(mode,mode_repeats)
		inner_beat += 1

		
		

