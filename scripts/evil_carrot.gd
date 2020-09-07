extends "res://scripts/abstracts/corruptable_enemy.gd"

var speed = 40
func set_mode(val):
	if (val == "attack"):
		$Sprite/AnimationPlayer.play("Rush")
		$Sprite/AnimationPlayer2.play("Chomp")
	elif ($Sprite/AnimationPlayer2.is_playing()):
		$Sprite/AnimationPlayer2.stop()
	elif (val == "evil"):
		$Sprite/AnimationPlayer.play("Idle")
	.set_mode(val)
func anim_finished(anim):
	if (anim == "Transform"):
		$health_bar.hp = 2
	.anim_finished(anim)
func run(player_pos,beat):
	match mode:
		"evil":
			if (player_pos.y > position.y):
				set_mode("attack")
		"attack":
			dmg_mv((player_pos-position).normalized()*speed,1)
			if (player_pos.y <= position.y):
				set_mode("evil")
