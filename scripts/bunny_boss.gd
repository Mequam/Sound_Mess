extends KinematicBody2D


func _ready():
	add_to_group("spiders")
	add_to_group("enemies")
	$NotePlayer.mode = 6
	$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Top")
var inner_beat = 0
var mode = "transition_strike"

func dir_anim(dir):
	if (1.5*abs(dir.x) > abs(dir.y)):
		print("scale.x " + str(scale.x))
		if (dir.x > 0 and $Bunny_Boss_Sprite.scale.x > 0):
			$Bunny_Boss_Sprite.scale.x *= -1
		elif (dir.x < 0 and $Bunny_Boss_Sprite.scale.x < 0):
			$Bunny_Boss_Sprite.scale.x *= -1
		$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Side")
	else:
		$Bunny_Boss_Sprite/AnimationPlayer2.play("Idle_Top")
	print("scale.x " + str(scale.x))
func move(player_pos):
	match mode:
		"transition_strike":
			var dir = (player_pos-position).normalized()
			move_and_collide(80*dir)
			dir_anim(dir)
func run(player_pos,beat):
	match inner_beat:
		0:
			$Bunny_Boss_Sprite/AnimationPlayer.play("left_leg_out")
			$NotePlayer.play_note(-7)
		1:
			$Bunny_Boss_Sprite/AnimationPlayer.play("Idle")
			$NotePlayer.play_note(-5)
			move(player_pos)
		2:
			$Bunny_Boss_Sprite/AnimationPlayer.play("mid_leg_out")
			$NotePlayer.play_note(-3)
		3:
			$Bunny_Boss_Sprite/AnimationPlayer.play("Idle")
			$NotePlayer.play_note(-6)
			move(player_pos)
		4:
			$Bunny_Boss_Sprite/AnimationPlayer.play("right_leg_out")
			$NotePlayer.play_note(-4)
		5:
			$Bunny_Boss_Sprite/AnimationPlayer.play("Idle")
			$NotePlayer.play_note(-6)
			move(player_pos)
		_:
			$NotePlayer.stop()
	inner_beat += 1
	if (inner_beat == 6):
		inner_beat = 0
