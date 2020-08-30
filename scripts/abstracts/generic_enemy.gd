extends KinematicBody2D

func _ready():
	add_to_group("enemies")
func on_col(obj,dmg):
	$health_bar.hp -= dmg
	if ($health_bar.hp <= 0):
		queue_free()
func run(player_pos,beat):
	pass
