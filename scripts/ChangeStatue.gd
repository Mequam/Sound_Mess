extends "res://scripts/singingSwitch.gd"

var scale_to_change_to : int = 1
func _ready():
	$AvatarSwapper.scale.x /= scale.x
	$AvatarSwapper.scale.y /= scale.y
	$AvatarSwapper.display_avatar(scale_to_change_to)
func _on_DialogChoiceList_completed_dialog(dialog):
	if player != null:
		var prev_scale = player.get_node("avatar").code
		
		player.load_avatar_enum(scale_to_change_to)
		scale_to_change_to = prev_scale
		player.talking = false
		$AvatarSwapper.display_avatar(scale_to_change_to)
		#remove our reference
		player = null
func _on_ChangeStatue_body_entered(body):
	body.set_musical_input_mode(scale_to_change_to)
	._on_singingSwitch_body_entered(body)
func _on_ChangeStatue_body_exited(body):
	#re-set the inputs to use the note native to the initial avatar
	body.set_musical_input_mode(body.get_node("avatar").code)
	._on_singingSwitch_body_exited(body)
