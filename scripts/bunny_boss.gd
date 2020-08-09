extends KinematicBody2D


func _ready():
	add_to_group("spiders")
	add_to_group("enemies")
	$NotePlayer.mode = 6
	$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Top")
var inner_beat = 0
var mode = "transition_strike"

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
func move(player_pos,inner_beat):
	match mode:
		"transition_strike":
			var local = player_pos-position
			var m = Transform2D()
			#the direction we are aiming
			m.x = local.normalized()
			#this is a fancy way of rotating 90 degrees counter clockwise with matrixes
			m.y = Vector2(local.y*-1,local.x).normalized()
		
			var dir
			match inner_beat:
				1:
					dir = m.basis_xform(Vector2(50,100))
				3:
					dir = m.basis_xform(Vector2(50,100))
				5:
					dir = m.basis_xform(Vector2(200,100))
			if (dir != null):
				move_and_collide(dir)
				dir_anim(-m.basis_xform(Vector2(0,1)),.6)
func run(player_pos,beat):
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
