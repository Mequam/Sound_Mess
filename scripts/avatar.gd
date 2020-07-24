extends Node2D

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
func play_idle():
	$Sprite/AnimationPlayer.play("Idle")
func anim_finished(anim):
	play_idle()
#this function has to set the parent mode to the desired value
func _ready():
	$Sprite/AnimationPlayer.connect("animation_finished",self,"anim_finished")
#runs the special corisponding to 6
func run_six(to_move,delta):
	pass
#run the special ability orisponding to 7
func run_seven(to_move,delta):
	pass

#this function is to be overiden in order to animate based on the direction of motion
func dir_anim(dir):
	pass
func run_flavor(flavor,to_move,delta):
	match flavor:
		6:
			return run_six(to_move,delta)
		7:
			return run_seven(to_move,delta)
	return 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
