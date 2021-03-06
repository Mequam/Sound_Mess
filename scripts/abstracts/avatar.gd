extends Node2D
#a code which uniquely identifies each avatar
var code : int
#this is a function that sets the mode of the player note player
#it is inteanded to be used by other avatars to tell the player
#what scale to play
func set_mode(mode : int):
	get_parent().set_musical_input_mode(mode)
#this function sets the colors of the text bubble for the player
func set_speech_color(textColor : Color,bubbleColor : Color):
	var sb = get_parent().get_node("SpeechBubble")
	sb.note_color = textColor
	sb.back_color = bubbleColor
#called when an avatar is loaded in
func load_avatar():
	#we start off in our idle state
	play_idle()
	#make sure that the parent responds properly when we leave the tree
	connect("tree_exited",get_parent(),"_on_avatar_tree_exited")
#called when an avatar is loaded out e.g. replaced
func clean_avatar():
	pass
var in_time setget set_in_time, get_in_time
func set_in_time(val):
	pass
func get_in_time():
	return (get_parent().rythom_score >= 2)

var last_beat setget set_last_beat,get_last_beat
func set_last_beat(val):
	get_parent().last_beat = val
func get_last_beat():
	return get_parent().last_beat

var sub_beat setget set_sub_beat,get_sub_beat
func set_sub_beat(val):
	get_parent().sub_beat = val
func get_sub_beat():
	return get_parent().sub_beat

func make_dir(v2):
	var n = 1.0/sqrt(v2.x*v2.x+v2.y*v2.y)
	return Vector2(n*v2.x,n*v2.y)
func play_idle(last_anim = "Move_Front"):
	match last_anim:
		"Move_Front":
			#plays the front facing animation
			$Sprite/AnimationPlayer.play("Idle")
		"Move_Left":
			#plays the left facing animation
			$Sprite/AnimationPlayer.play("Idle_Left")
		"Move_Back":
			$Sprite/AnimationPlayer.play("Idle_Back")
		_:
			#plays the front facing animation
			$Sprite/AnimationPlayer.play("Idle")
func anim_finished(anim):
	play_idle(anim)
#this function has to set the parent mode to the desired value
func init():
	$Sprite/AnimationPlayer.connect("animation_finished",self,"anim_finished")
#runs the special corisponding to 6
func run_six(to_move,delta):
	return 1.0
func run_seven(to_move,delta):
	return 1.0
func run_flavorless(to_move : Vector2,delta : float)->float:
	return 1.0
func clean_six(to_move,delta):
	return 1
func clean_seven(to_move,delta):
	return 1
func clean_flavorless(to_move : Vector2,delta : float):
	return 1
func flavor_changed(flavor):
	pass
#this function is the default animation behavior of every avatar
func dir_anim(dir : Vector2 ,prefix : String ="")-> void:
	#make sure that the sprite is not backwoards before begining the animation
	if ($Sprite.scale.x < 0):
		$Sprite.scale.x *= -1
	#are we moving more up and down or left and right?
	if (abs(dir.y) > abs(dir.x)):
		if (dir.y > 0):
			#up and down
			$Sprite/AnimationPlayer.play(prefix+"Move_Front")
		else:
			$Sprite/AnimationPlayer.play(prefix+"Move_Back")
	elif (dir.x > 0):
		#right
		#invert the sprite when moving right
		$Sprite.scale.x *= -1
		$Sprite/AnimationPlayer.play(prefix+"Move_Left")
	elif (dir.x < 0):
		#left
		$Sprite/AnimationPlayer.play(prefix+"Move_Left")
	$Sprite/Shrinking_Triangle.emit_dir_pos(
		Vector2((dir.x*$Sprite.scale.x/abs($Sprite.scale.x)),
				dir.y
				))
func run_flavor(flavor,to_move,delta):
	match flavor:
		7:
			return run_six(to_move,delta)
		6:
			return run_seven(to_move,delta)
	return run_flavorless(to_move,delta)
func clean_flavor(flavor,to_move,delta):
	match flavor:
		7:
			return clean_six(to_move,delta)
		6:
			return clean_seven(to_move,delta)
	return clean_flavorless(to_move,delta)
