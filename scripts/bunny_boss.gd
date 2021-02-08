extends "res://scripts/abstracts/generic_boss.gd"

var scale_math = load("res://scripts/abstracts/Scale_Math.gd").new()
var init_col_layer
var init_col_mask
func main_ready():
	#call the generic ready function
	#this lets the save state node run before we do anything else
	.main_ready()
	#we are still a spider if we are dead
	add_to_group("spiders")
	#cache the initial collision layer
	init_col_layer = collision_layer
	init_col_mask = collision_mask
	#set the initial health
	$health_bar.hp = 20
	#set the mode of the music math
	scale_math.mode = 6
	$NotePlayer.mode = 6
	#the save state node will then update our state/mode,
	#if we are not dead, prepare to move, otherwise do nothing
	if mode != "dead":
		#save the initial collision layer
		$Sprite/AnimationPlayer2.play("Idle_Top")
		set_mode("move_circle")
	else:
		$health_bar.visible = false
var dieing_burrow_particle = load("res://scenes/instance/dieing_particle.tscn")
func set_mode(val):
	if (mode == "move_slam"):
		collision_layer = init_col_layer
		collision_mask = init_col_mask
	inner_beat = 0
	mode = val
	moving = mode.split("_")[0] == "move"
	match mode:
		"move_burrow":
			$Sprite/AnimationPlayer2.play("Burrow")
func get_mode():
	return mode

var moving = false
var burrow_radius = 1000
var burrow_speed = 200
var burrow_target_point : Vector2
func dir_anim(dir,x_wieght=1):
	if (float(x_wieght*abs(dir.x)) > float(abs(dir.y))):
		if (dir.x > 0 and $Sprite.scale.x > 0):
			$Sprite.scale.x *= -1
		elif (dir.x < 0 and $Sprite.scale.x < 0):
			$Sprite.scale.x *= -1
		$Sprite/AnimationPlayer2.play("Idle_Side")
	elif (dir.y > 0):
		$Sprite/AnimationPlayer2.play("Idle_Top")
	else:
		$Sprite/AnimationPlayer2.play("Idle_Back")
func get_ctx_matrix(player_pos):
	var local = player_pos-position
	var m = Transform2D()
	#the direction we are aiming
	m.x = local.normalized()
	#this is a fancy way of rotating 90 degrees counter clockwise with matrixes
	m.y = Vector2(local.y*-1,local.x).normalized()
	return m
var burrow_dir
#this funtion moves us a direction and damages anything that we hit
func move_dmg(dir):
	var col = move_and_collide(dir)
	if (col and col.collider.has_method("on_col")):
		col.collider.on_col(self,1)
	return col
func burrow_effect(n,unit,m=Transform2D(Vector2(1,0),Vector2(0,1),Vector2(0,0))):
	for i in range(0,n):
		var part = dieing_burrow_particle.instance()
		part.position = position+m.xform(-i*unit)
		get_tree().get_root().add_child(part)
func move(player_pos,inner_beat):
	match mode:
		"move_burrow":
			if (inner_beat == 1):
				var theta = (randf()*PI/2)+PI/4
				burrow_dir = (burrow_radius*Vector2(cos(theta),sin(theta)) + Vector2(position.distance_to(player_pos),0)).normalized()
			if (inner_beat >= 1 and inner_beat <= 8):
				if (burrow_dir != null):
					var m = get_ctx_matrix(player_pos)
					#select a random point on a circle of radius burrow_radius 
					#then move that point over the player in target space (where the player is on the x axis)
						
					#now create a vector of length burrow speed and point to that point
					var col = move_and_collide( #dont damage the player while were bieng spastic
						m.xform(
							burrow_dir*burrow_speed
							)
						)
					if !col:
						burrow_effect(4,burrow_dir*burrow_speed/4,m)
			if(inner_beat == 9):
				#set up the target direction for the future
				burrow_dir = (player_pos-position).normalized()*burrow_speed
				
				#dont move too close to the player on the first beat
				var to_move = burrow_dir*.7
				if (player_pos.distance_to(position) <= 200):
					to_move *= -1
				move_dmg(to_move)
				burrow_effect(4,to_move/4)
			if (inner_beat >= 12 and inner_beat%3==0):
				for i in get_tree().get_nodes_in_group("trapers"):
					if check_rad(70,i.position,burrow_dir):
						i._on_Traper_Entity_body_entered(self)
				move_dmg(burrow_dir)
				#because our movment is "teleportish" we have to check to see if we crossed over an enemy that can harm us
				burrow_effect(4,burrow_dir/4)
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
					position = player_pos
				2:
					$Sprite/AnimationPlayer2.play("Front_Slash_Windup")
				4:
					$Sprite/AnimationPlayer2.play("Front_Slash")
			return 5
		"move_slam":
			match inner_beat:
				2:
					collision_mask = 0
					collision_layer = 0
					position = player_pos
					$Sprite/AnimationPlayer2.play("Front_Slash_Windup")
				6:
					collision_mask = init_col_mask
					collision_layer = init_col_layer
					var col = move_dmg(Vector2(0,0))
					if (col and col.collider.has_method("on_col")):
						col.collider.on_col(self,3)
						
			return 10
func on_col(obj,dmg):
	$health_bar.hp -= dmg*2
	if ($health_bar.hp <= 0):
		die()

#checks if a given point goes through a given circle
func check_rad(r : float,c : Vector2,p : Vector2):
	#make sure c is in our chord space
	c = c-position
	var c_angle = c.angle()
	var origin = Vector2(0,0)
	var theta = asin(r/c.distance_to(origin))
	var p_angle = p.angle()
	return r*r >= p.distance_squared_to(c) or (c_angle-theta <= p_angle and c_angle+theta >= p_angle and p.distance_squared_to(origin) > c.distance_squared_to(origin))
func play_beats(mode):
	match mode:
		"move_circle":
			match (inner_beat-1):
					0:
						$Sprite/AnimationPlayer.play("left_leg_out")
						$NotePlayer.play_note(-7)
					1:
						$Sprite/AnimationPlayer.play("Idle")
						$NotePlayer.play_note(-5)
						
					2:
						$Sprite/AnimationPlayer.play("mid_leg_out")
						$NotePlayer.play_note(-3)
					3:
						$Sprite/AnimationPlayer.play("Idle")
						$NotePlayer.play_note(-6)
					4:
						$Sprite/AnimationPlayer.play("right_leg_out")
						$NotePlayer.play_note(-4)
					5:
						$Sprite/AnimationPlayer.play("Idle")
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
func die():
	#make sure we play our animation on death
	$Sprite/AnimationPlayer2.play("Death")
	.die()
