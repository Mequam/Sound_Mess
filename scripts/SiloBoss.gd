extends "res://scripts/abstracts/corruptable_enemy.gd"
#this is the blue-print for the falling carrots that we throw while in shake mode
var thrownCarrot = preload("res://scenes/instance/FallingCarrot.tscn")

#this is used so we can re-use the same behavior for different modes
#while changing a thing or too with the exist states
var sub_mode : String

#this is the amount of carrots that we have spawned
#we use this to modulate difficulty
var carrotCount : int = 0

#the speed that we move when moving
var speed : float = 100

var movePos : Vector2 = Vector2(0,0) setget set_movePos,get_movePos
func set_movePos(val : Vector2) -> void:
	movePos = val
func get_movePos():
	return movePos

#used by the rush mode as the location to move to 
var moveDir : Vector2  setget set_moveDir,get_moveDir
func set_moveDir(val : Vector2) -> void:
	pass
func get_moveDir() -> Vector2:
	return (movePos-position).normalized()
#used to tell the mode that we came from for the ret mode
#to make a decision on what to do
var came_from : String

#stores our initial position that we return to
var init_pos : Vector2
func set_mode(val : String) -> void:
	#in every mode inner_beat gets re-set	
	inner_beat = 0
	#store the old mode
	
	#ret is a transition mode,
	#it is not helpful to know that we are coming out of ret
	#instead it is helpfull to know the previous mode
	if sub_mode != "ret":
		#we care about the sub modes, not the primary mode when we are using sub modes
		if mode == "move":
			came_from = sub_mode
		else:
			came_from = mode
	else:
		#get out of the ret sub mode loop
		sub_mode = ""
	
	#re-direct evil to idle
	if val == "evil":
		val = "idle"
	
	if val == "idle":
		$Sprite/AnimationPlayer.play("Idle")
	elif val == "shake":
		#when we shake we use the same animation as walk at double speed
		$Sprite/AnimationPlayer.play("Walk",-1,2)
	elif val == "rush":
		val = "move"
		sub_mode = "rush"
	elif val == "ret":
		set_movePos(init_pos)
		val = "move"
		sub_mode = "ret"
	elif val == "smash":
		$Sprite/AnimationPlayer.play("Walk",-1,1.5)
	elif val == "smashing":
		$Sprite/AnimationPlayer.play("Smash")
	if val == "move":
		$Sprite/AnimationPlayer.play("Walk")
	mode = val
	.set_mode(val)
	print("[silo boss] mode set to " + str(mode))

func spawn_carrot()->void:
	var carrot = thrownCarrot.instance()
	#this event passes the carrot that is spawned so we can interact with it
	#to set hooks to know when it dies
	carrot.connect("spawning_carrot",self,"_on_carrot_spawn")
	var dir = Vector2(0,1)
	carrot.speed = 600*(randf()+0.4)
	#the direction that the carrot falls
	carrot.move_vec = dir.rotated((randf()*(PI-0.05)) - ((PI-0.05)/2))
	get_tree().get_root().add_child(carrot)
	
	carrot.position = position+Vector2(0,(-150))
	carrot.fall()

func _on_carrot_spawn(carrot) -> void:
	#make sure that we know when the carrot dies
	carrot.connect("die",self,"_on_carrot_die")
	carrotCount += 1
func _on_carrot_die(carrot):
	carrotCount -= 1

func corrupt() -> void:
	$Sprite/siloPos/siloSpriteAnimation.animation = "Shake"
	$Sprite/siloPos/siloSpriteAnimation.playing = true
	#let the default behavior run
	.corrupt()

#overide the default behavior so that we turn evil when we play 
#the last animation
func anim_finished(anim : String)->void:
	if anim == "Shake4":
		add_to_group("enemies")
		set_mode("evil")
	elif anim == "Smash":
		#TODO: there has got to be a cleaner way to impliment
		#this smash feature
		if player_in_smash_zone:
			for node in get_tree().get_nodes_in_group("player"):
				node.on_col(self,3)
		set_mode("ret")
		#we have a few options here
#this function is in charge of playing music and updating the display
#of the enemy to the music
func play_note(inner_beat) -> void:
	match mode:
		"shake":
			match (inner_beat%6):
				0:
					$NotePlayer.play_note(4)
				1:
					$NotePlayer.play_note(3)
				2:
					$NotePlayer.play_note(4)
				3:
					$NotePlayer.play_note(0)
				4:
					$NotePlayer.play_note(1)
				5:
					$NotePlayer.play_note(0)
				_:
					$NotePlayer.stop()
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
func run(player_pos : Vector2,beat)-> void:
	#run the display that is dependent on the 
	#note player
	play_note(inner_beat)
	#run the AI
	match mode:
		"smash":
			var target_pos : Vector2
			var offset : Vector2 = Vector2(300,0)
			if player_pos.x > position.x:
				$Sprite.scale.x =  abs($Sprite.scale.x)*(-1)
				target_pos = player_pos - offset
			else:
				$Sprite.scale.x = abs($Sprite.scale.x)
				target_pos = player_pos + offset
			var col = dmg_mv((target_pos-position).normalized()*speed*1.78,2)
			if player_in_smash_zone:
				set_mode("smashing")
		"move":
			#move in the last scene direction of the player
			var col = dmg_mv(get_moveDir()*speed,2)
			if col or position.distance_squared_to(get_movePos()) < speed*speed*.25:
				match sub_mode:
					"rush":
						if $health_bar.hp < 5:
							set_mode("shake")
						else:
							set_mode("ret")
					"ret":
						match came_from:
							"shake":
								if $health_bar.hp < 5:
									set_mode("smash")
								else:
									set_mode("idle")
							_:
								set_mode("idle")
		"idle":
			inner_beat += 1
			if inner_beat > 15: 
				print("[silo boss] carrot count " + str(carrotCount))
				print("[silo boss] came from " + str(came_from))
				match came_from:
					"rush":
						#if we are on low health ease conditions on the carrot spawning
						if ($health_bar.hp <= 5 and carrotCount < 10) or carrotCount < 5:
							set_mode("shake")
						else:
							set_mode("smash")
					"smashing":
						set_movePos(player_pos)
						set_mode("rush")
					_:
						set_movePos(player_pos)
						set_mode("rush")
		"shake":
			#spawn ALL the carrots
			if $health_bar.hp <= 5 or (inner_beat % 2) == 0:
				spawn_carrot()
			inner_beat += 1
			if inner_beat > 15:
				set_mode("idle")
				
func _ready():
	$health_bar.hp = 10
	init_pos = position

#used to determine whether or not we can smash the player
var player_in_smash_zone : bool = false
func _on_smashZone_body_entered(body):
	if body.name and body.name == "player":
		player_in_smash_zone = true
func _on_smashZone_body_exited(body):
	if body.name and body.name == "player":
		player_in_smash_zone = false
