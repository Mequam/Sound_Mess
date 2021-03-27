extends "res://scripts/abstracts/generic_area.gd"

func gen_col_layer()->int:
	return col_math.Layer.ENEMY #we are an enemy
func gen_col_mask()->int:
	return col_math.Layer.PLAYER | col_math.Layer.ENEMY #we collide with other enemeis
var inner_beat = 0.0

#the last enemy that enterd our circle
var inside = null
var backwords = false
var mode = "idle"

var leg_color setget set_leg_color,get_leg_color
func get_leg_color():
	return $Traper.leg_color
func set_leg_color(color):
	$Traper.leg_color = color
#how much damage we do each hit
var dmg = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	add_to_group("spiders")
	add_to_group("trapers")
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
			$NotePlayer.volume_db-=12
			$Traper/AnimationPlayer.play("Idle")
			backwords = false
			mode="idle"
		#tell whatever we jist hit they got owned
		if (is_instance_valid(inside) and inside.has_method("on_col")):
			inside.on_col(self,dmg)
func run_wrapper(player_pos,beat):
	run(player_pos,beat)
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
		$NotePlayer.volume_db+=12
		for eye in $Traper/spdier/head/eyes.get_children():
			eye.visible = true
		mode="attack"
		
		
