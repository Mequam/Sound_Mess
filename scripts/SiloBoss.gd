extends "res://scripts/abstracts/corruptable_boss.gd"
#we start off as any old terrain
func gen_col_layer():
	return col_math.Layer.TERRAIN
func gen_col_mask():
	return 0

#this is the blue-print for the falling carrots that we throw while in shake mode
var thrownCarrot = preload("res://scenes/instance/FallingCarrot.tscn")

func on_col(node : Node,dmg : int) -> void:
	#we ignore carrot based monch damage and dammage when we are terrain
	if not node.is_in_group("carrot") and collision_layer != col_math.Layer.TERRAIN:
		.on_col(node,dmg)
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
	#make sure that we stop the notes from playing
	$NotePlayer.stop()
	
	#the inner beat is used to keep track of the musical note that we are on
	#the rush and return values have the same continued music
	if val != "ret":
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
	elif val == "shake_move":
		val = "move"
		sub_mode = "shake_move"
	if val == "move":
		$Sprite/AnimationPlayer.play("Walk")
	mode = val
	.set_mode(val)

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
	#so we can run our transform music
	add_to_group("enemies")
	#let the default behavior run
	.corrupt()

#overide the default behavior so that we turn evil when we play 
#the last animation
func anim_finished(anim : String)->void:
	if anim == "Shake4":
		#we basically just finished a stitched together transform
		#animation, let the transform inheritience class take over
		$health_bar.visible = true
		#stop playing the unstable animation after we transform
		$Sprite/siloPos/siloSpriteAnimation.playing = false
		.anim_finished("Transform")
	elif anim == "Smash":
		#TODO: there has got to be a cleaner way to impliment
		#this smash feature
		if get_player_in_smash_zone():
			#call the damage routine on the node we hit
			node_in_smash_zone.on_col(self,3)
		set_mode("ret")
		#we have a few options here
#this function is in charge of playing music and updating the display
#of the enemy to the music
func play_note(inner_beat) -> void:
	match mode:
		"still":
			match (inner_beat%4):
				0:
					$NotePlayer.play_note(-3)
				2:
					$NotePlayer.play_note(-7)
				_:
					$NotePlayer.stop()
		"smashing":
			#climb up then rappidly smash down the notes to the root
			match (inner_beat):
				0:
					$NotePlayer.play_note(-7)
				1:
					$NotePlayer.play_note(0)
				2:
					$NotePlayer.play_note(-7)
				_:
					$NotePlayer.stop()
		"smash":
			#simple looped arpegio
			match (inner_beat%3):
				0:
					$NotePlayer.play_note(-7)
				1:
					$NotePlayer.play_note(-5)
				2:
					$NotePlayer.play_note(-3)
				_:
					$NotePlayer.stop()
		"move":
			#calls back to the initial 1-5 (0-4) call of the carrots,
			#but loops up and down a ton to add more complexity
				match (inner_beat%8):
					0:
						$NotePlayer.play_note(-7)
					1:
						$NotePlayer.play_note(-5)
					2:
						$NotePlayer.play_note(-3)
					3:
						$NotePlayer.play_note(-5)
					4:
						$NotePlayer.play_note(-7)
					5:
						$NotePlayer.play_note(-5)
					6:
						$NotePlayer.play_note(-4)
					7:
						$NotePlayer.play_note(-2)
					_:
						$NotePlayer.stop()
		"shake":
			match (inner_beat%6):
				0:
					$NotePlayer.play_note(-3)
				1:
					$NotePlayer.play_note(-4)
				2:
					$NotePlayer.play_note(-3)
				3:
					$NotePlayer.play_note(-7)
				4:
					$NotePlayer.play_note(-6)
				5:
					$NotePlayer.play_note(-7)
				_:
					$NotePlayer.stop()
		"idle":
			match inner_beat:
				0:
					$NotePlayer.play_note(-3)
					$Sprite/NoteDetails.play("TopLookLeft")
				2:
					$NotePlayer.play_note(-4)
					$Sprite/NoteDetails.play("MidLookLeft")
				4:
					$NotePlayer.play_note(-3)
					$Sprite/NoteDetails.play("NoramalLook")
				6:
					$NotePlayer.play_note(-7)
					$Sprite/NoteDetails.play("BottomLookLeft")
				8:
					$NotePlayer.play_note(-6)
					$Sprite/NoteDetails.play("BottomLookRight")
				10:
					$NotePlayer.play_note(-7)
					$Sprite/NoteDetails.play("BottomLookLeft")
				12:
					$NotePlayer.play_note(-4)
					$Sprite/NoteDetails.play("BottomLookDown")
				14:
					$NotePlayer.play_note(-7)
					$Sprite/NoteDetails.play("NoramalLook")
				_:
					$NotePlayer.stop()

#used to alternate wheather or not we run the shake-move attack
#we only run it if this is true among other conditions
var run_shake_move = false

func run(player_pos : Vector2,beat)-> void:
	#run the display that is dependent on the 
	#note player
	play_note(inner_beat)
	inner_beat += 1
	#run the AI
	match mode:
		"smash":
			var target_pos : Vector2
			var offset : Vector2 = Vector2(300,0)
			var correctional_mult = 1
			#how far away from the player we are
			var distSquared = position.distance_squared_to(target_pos)
			
			#look at the player
			if player_pos.x > position.x:
				$Sprite.scale.x =  abs($Sprite.scale.x)*(-1)
				target_pos = player_pos - offset
			else:
				$Sprite.scale.x = abs($Sprite.scale.x)
				target_pos = player_pos + offset
			
			#a vector from us to the target
			var vec_at_target = (target_pos-position)
			#our speed vector
			var move_vec = vec_at_target.normalized()*speed*1.78
			
			var to_move = move_vec
			#if we are going to over jump the point, don't
			if move_vec.length_squared() > vec_at_target.length_squared():
				to_move = vec_at_target
			
			var col = dmg_mv(to_move,2)
			
			if get_player_in_smash_zone() or inner_beat > 16:
				set_mode("smashing")
		"move":
			#move in the last scene direction of the player
			var col = dmg_mv(get_moveDir()*speed,2)
			if col or position.distance_squared_to(get_movePos()) < speed*speed*.25:
				match sub_mode:
					"shake_move":
						set_mode("shake")
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
			if inner_beat > 15: 
				match came_from:
					"rush":
						#if we are on low health ease conditions on the carrot spawning
						if ($health_bar.hp <= 5 and carrotCount < 5) or carrotCount < 2:
							set_mode("shake")
						else:
							set_mode("smash")
					"smashing":
						set_movePos(player_pos)
						set_mode("rush")
					_:
						if run_shake_move:
							set_movePos(position+Vector2(0,-500))
							set_mode("shake_move")
						else:
							set_movePos(player_pos)
							set_mode("rush")
						run_shake_move = not run_shake_move
		"shake":
			#spawn ALL the carrots
			if $health_bar.hp <= 5 or (inner_beat % 2) == 0:
				spawn_carrot()
			if inner_beat > 15:
				if came_from == "shake_move":
					set_mode("ret")
				else:
					set_mode("idle")
func main_ready():
	#figure out weather or not we are dead
	$save_state_node.load_data()
	if (mode != "dead"):
		
		#set up our states
		$health_bar.hp = 20
		$health_bar.visible = false
		init_pos = position
		
		#this animation sets us up in a default state that
		#looks like we have not transformed yet
		#if we don't play this then we look dead
		$Sprite/AnimationPlayer.play("TransformStart")
		$Sprite/siloPos/siloSpriteAnimation.animation = "Idle"
		
		#this has the code that puts us into the corruptable group
		#if this is not run we are basically not an entity
		.main_ready()

#used to determine whether or not we can smash the player
var player_in_smash_zone : bool setget set_player_in_smash_zone,get_player_in_smash_zone
func set_player_in_smash_zone(val : bool) -> void:
	pass
func get_player_in_smash_zone() -> bool:
	return (node_in_smash_zone != null)
#death behavior
func die()->void:
	#we are now part of the terrain
	collision_layer = col_math.Layer.TERRAIN
	collision_mask = 0
	.die()
var node_in_smash_zone : Node2D = null
func _on_smashZone_body_entered(body):
	if body.name and body.name == "player":
		node_in_smash_zone = body
func _on_smashZone_body_exited(body):
	if body.name and body.name == "player":
		node_in_smash_zone = null
