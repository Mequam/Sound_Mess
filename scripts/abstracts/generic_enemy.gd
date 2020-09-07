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

#moves in a direction and damages anything we come accross
func dmg_mv(dir,dmg):
	var col = move_and_collide(dir)
	if (col):
		print("evil collision!")
	if (col and col.collider.has_method("on_col")):
		print("evil damage!")
		col.collider.on_col(self,dmg)
	return col
#virtual functions
func anim_finished(anim):
	pass
func run(player_pos,beat):
	pass
