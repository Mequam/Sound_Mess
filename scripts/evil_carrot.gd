extends "res://scripts/abstracts/corruptable_enemy.gd"

var speed = 40
func set_mode(val):
	if (val == "attack"):
		$Sprite/AnimationPlayer.play("Rush")
	elif (val == "evil"):
		$Sprite/AnimationPlayer.play("Idle")
	.set_mode(val)
func anim_finished(anim):
	if (anim == "Transform"):
		$health_bar.hp = 2
		$dirt_front.queue_free()
		$dirt_back.queue_free()
		collision_layer = 4
		collision_mask = 5
		$Sprite/body.z_index = 0
		$Sprite/evil.z_index = 0
	.anim_finished(anim)
func play_note(mode):
	match mode:
		"attack":
			match inner_beat:
				0:
					$NotePlayer.play_note(4)
					$Sprite/AnimationPlayer2.play("Open")
				1:
					$NotePlayer.play_note(0)
					$Sprite/AnimationPlayer2.play("Close")
				_:
					$NotePlayer.stop()
			inner_beat += 1
			if (inner_beat >= 2):
				inner_beat = 0
		"evil":
			match inner_beat:
				0:
					$NotePlayer.play_note(0)
					$Sprite/AnimationPlayer2.play("Look_forward")
				3:
					$NotePlayer.play_note(4)
					$Sprite/AnimationPlayer2.play("Look_down_left")
				4:
					$Sprite/AnimationPlayer2.play("Look_down_right")
					$NotePlayer.play_note(3)
				_:
					$NotePlayer.stop()
			inner_beat += 1
			if (inner_beat >= 5):
				inner_beat = 0
func _ready():
	$Sprite/body.z_index = -1
	$Sprite/evil.z_index = -1
	$NotePlayer.mode = 6
func run(player_pos,beat):
	match mode:
		"evil":
			if (player_pos.y > position.y):
				set_mode("attack")
		"attack":
			dmg_mv((player_pos-position).normalized()*speed,1)
			if (player_pos.y <= position.y):
				set_mode("evil")
			if (player_pos.x < position.x):
				print("looking left!")
				$Sprite/AnimationPlayer2.play("Look_down_left")
			else:
				$Sprite/AnimationPlayer2.play("Look_down_right")
	play_note(mode)
