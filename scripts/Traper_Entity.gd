extends Area2D
var inner_beat = 0.0
#the last enemy that enterd our circle
var inside = null
var backwords = false
var mode = "idle"
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	add_to_group("spiders")
	$NotePlayer.mode = 6
	$Traper/AnimationPlayer.play("Idle")
	$Traper/AnimationPlayer.connect("animation_finished",self,"_anim_finished")
func _anim_finished(anim):
	if (anim == "Attack"):
		#impliment the ping pong stile of animation
		if (!backwords):
			$Traper/AnimationPlayer.play_backwards("Attack")
			backwords = true
		else:
			$Traper/AnimationPlayer.play("Idle")
			backwords = false
			mode="idle"
		#tell whatever we jist hit they got owned
		if (inside and inside.has_method("on_col")):
			inside.on_col(self)
func run(player_pos,beat):
	match inner_beat:
		0:
			$Traper/spdier/head/eyes/eye1.visible = false
			$NotePlayer.play_note(0)
		4:
			$Traper/spdier/head/eyes/eye3.visible = false
			$NotePlayer.play_note(3)
		8:
			$Traper/spdier/head/eyes/eye2.visible = false
			$NotePlayer.play_note(4)
		_:
			for eye in $Traper/spdier/head/eyes.get_children():
				eye.visible = true
			$NotePlayer.stop()
	if (mode == "idle"):
		inner_beat+=1
	else:
		inner_beat+=4
	if (inner_beat >= 12):
		inner_beat = 0

func _on_Traper_Entity_body_entered(body):
	if (body.has_method("on_col")):
		inside = body
	#run the attack animation
	inner_beat = 0
	if ($Traper/AnimationPlayer.assigned_animation != "Attack"):
		$Traper/AnimationPlayer.play("Attack")
		for eye in $Traper/spdier/head/eyes.get_children():
			eye.visible = true
		mode="attack"
		
		
