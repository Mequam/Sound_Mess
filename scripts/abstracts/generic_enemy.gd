extends KinematicBody2D
var mode = "default" setget set_mode,get_mode
func set_mode(val):
	mode = val
func get_mode():
	return mode
func _ready():
	add_to_group("enemies")
	if (get_node("Sprite")):
		$Sprite/AnimationPlayer.connect("animation_finished",self,"anim_finished")
func on_col(obj,dmg):
	$health_bar.hp -= dmg
	if ($health_bar.hp <= 0):
		queue_free()

#virtual functions
func anim_finished(anim):
	pass
func run(player_pos,beat):
	pass
