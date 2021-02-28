extends "res://scripts/abstracts/projectile.gd"
func _ready():
	speed = 1600
func on_hit(col : KinematicCollision2D,delta : float) -> void:
	if col.collider.has_method("move_and_collide"):
		col.collider.move_and_collide(dir*speed*2*delta)
	.on_hit(col,delta)
