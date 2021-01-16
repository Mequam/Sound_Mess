extends "res://scripts/abstracts/corruptable_enemy.gd"
func set_mode(val : String) -> void:
	if val == "evil":
		val = "idle"
	if val == "idle":
		$Sprite/AnimationPlayer.play("Idle")
	mode = val
	.set_mode(val)
	print("[silo boss] mode set to " + str(mode))
func corrupt() -> void:
	$Sprite/siloPos/siloSpriteAnimation.animation = "Shake"
	$Sprite/siloPos/siloSpriteAnimation.playing = true
	#let the default behavior run
	.corrupt()

#overide the default behavior so that we turn evil when we play 
#the last animation
func anim_finished(anim):
	if anim == "Shake4":
		add_to_group("enemies")
		set_mode("evil")
	elif anim == "idle":
		pass
		#we have a few options here

#this function is in charge of playing music and updating the display
#of the enemy to the music
func play_note(inner_beat) -> void:
	match mode:
		"idle":
			match inner_beat:
				0:
					$NotePlayer.play_note(4)
					$Sprite/NoteDetails.play("TopLookLeft")
				2:
					$NotePlayer.play_note(3)
					$Sprite/NoteDetails.play("MidLookLeft")
				4:
					$NotePlayer.play_note(4)
					$Sprite/NoteDetails.play("NoramalLook")
				6:
					$NotePlayer.play_note(0)
					$Sprite/NoteDetails.play("BottomLookLeft")
				8:
					$NotePlayer.play_note(1)
					$Sprite/NoteDetails.play("BottomLookRight")
				10:
					$NotePlayer.play_note(0)
					$Sprite/NoteDetails.play("BottomLookLeft")
				12:
					$NotePlayer.play_note(3)
					$Sprite/NoteDetails.play("BottomLookDown")
				14:
					$NotePlayer.play_note(0)
					$Sprite/NoteDetails.play("NoramalLook")
				_:
					$NotePlayer.stop()
func run(player_pos,beat)-> void:
	#run the display
	play_note(inner_beat)
	#manage the inner_beat
	inner_beat += 1
	#run the AI
	match mode:
		"idle":
			if inner_beat > 15:
				inner_beat = 0
func _ready():
	pass
