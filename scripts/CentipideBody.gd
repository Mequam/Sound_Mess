extends CentiRail

class_name CentiBody

#this class controls the animation of the centipide body segments and the specific
#case of collision with the player


#functions used to signal player collision with the tail
#emited when the player enters the body to pass along that fact up the chain
func pass_player_entered(player : Player,segment : CentiBody)->void:
	get_parent().pass_player_entered(player,segment)

var anim_state : String setget set_anim_state,get_anim_state
func set_anim_state(val : String)->void:
	#process state update here
	match val:
		"Frozen":
			$Sprite/AnimationPlayer.stop()
	#pass on state update here
	if get_child(0) and get_child(0).has_method("set_anim_state"):
		get_child(0).set_anim_state(val)

#query the chain to find our animation state
func get_anim_state()->String:
	var parent = get_parent()
	if parent.has_method("get_anim_state"):
		return get_parent().get_anim_state()
	return "Run"

#syntactic sugar function that determines wether or not we should have our animations horizontally
func vertical_animation()->bool:
	#the angle that we allow the body segment to be horiontal on
	var VERTICAL_ANGLE = PI / 2
	return abs(angle) < (PI/2 + VERTICAL_ANGLE/2) and abs(angle) > (PI/2 - VERTICAL_ANGLE/2)

#syntactic sugar that helps determine of an animation should be playing
func should_play(anim : String)->bool:
	return $Sprite/AnimationPlayer.assigned_animation != anim or not $Sprite/AnimationPlayer.is_playing()

func _process(delta):
	match get_anim_state():
		"Run":	#we are not currently playing side_run																		#should we be?
			if  should_play("Side_Run") and not vertical_animation():
				$Sprite/AnimationPlayer.play("Side_Run")
			elif should_play("Run") and vertical_animation():
				$Sprite/AnimationPlayer.play("Run")
	var player : Player = Globals.get_scene_root().get_node("player") as Player
	if global_position.distance_squared_to(player.global_position) < 2500:
		pass_player_entered(player,self)
