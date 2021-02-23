extends "res://scripts/abstracts/projectile.gd"
#we hit enemies
func gen_col_mask() -> int:
	return col_math.Layer.ENEMY
#nothing hits us
func gen_col_layer()->int:
	return 0
func _ready():
	speed = 1600
func on_hit(col : KinematicCollision2D,delta : float) -> void:
	col.collider.move_and_collide(dir*speed*2*delta)
	.on_hit(col,delta)
