extends KinematicBody2D


func _ready():
	add_to_group("spiders")
	add_to_group("enemies")
	$NotePlayer.mode = 6
	$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Top")
	set_mode("move_circle")

var inner_beat = 0
var dieing_burrow_particle = load("res://scenes/instance/dieing_particle.tscn")
var mode = "move_circle" setget set_mode,get_mode
func set_mode(val):
	mode = val
	moving = mode.split("_")[0] == "move"
	match mode:
		"move_burrow":
			$Bunny_Boss_Sprite/AnimationPlayer2.play("Burrow")
func get_mode():
	return mode

var moving = false
var burrow_radius = 200
var burrow_speed = 200

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
	match mode:
		"move_burrow":
			match inner_beat:
				0:
					var theta = (randf()*PI/2)+PI/4
					#print("theta " + str(theta))
					print(burrow_radius*Vector2(cos(theta),sin(theta)) + Vector2(position.distance_to(player_pos),0))
					burrow_dir = (burrow_radius*Vector2(cos(theta),sin(theta)) + Vector2(position.distance_to(player_pos),0)).normalized()
				_:
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
		"move_circle":
			var m = get_ctx_matrix(player_pos)
			
			var dir
			match inner_beat:
				1:
					dir = m.basis_xform(Vector2(50,200))
				3:
					dir = m.basis_xform(Vector2(100,100))
				5:
					dir = m.basis_xform(Vector2(50,50))
			if (dir != null):
				move_and_collide(dir)
				dir_anim(-m.basis_xform(Vector2(0,1)),.6)
func run(player_pos,beat):
	if (moving):
		move(player_pos,inner_beat)
		match inner_beat:
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
	inner_beat += 1
	if (inner_beat == 6):
		inner_beat = 0

