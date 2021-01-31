extends "res://scripts/Tarantula.gd"
#this script is an animated tarantula which we use for the silo boss
#fight zone animation
#it is not inteanded to be clean or re-used

#we collide with nothing
func gen_col_layer()-> int:
	return 0
func gen_col_mask()->int:
	return 0
var can_corrupt = false
var can_attack = true


func set_mode(val : String) -> void:
	#do not let the parent code stop us from attacking,
	#there is only one mode for this animation and that mode is attack!
	if (can_corrupt and val == "Alert"):
		can_corrupt = false
		.set_mode(val)
	elif (not can_corrupt) and val =="Alert":
		queue_free()
	if (val == "Attack" and can_attack) or val == "Attack_Alert":
		if val == "Attack_Alert":
			z_index = 1
			can_attack = false
			position = get_parent().get_node("SiloBoss").position+Vector2(0,-415)
		.set_mode(val)
func _ready():
	#run to above the target
	target_pos = get_parent().get_node("SiloBoss").position + Vector2(0,-100)
	target_dir = (target_pos-position).normalized()
	set_mode("Attack")
func run(player_pos,beat):
	#we die after we corrupt
	if mode == "Alert" and inner_beat == 5:
		get_parent().get_node("super_particles").emitting = true
		queue_free()
	.run(player_pos,beat)
