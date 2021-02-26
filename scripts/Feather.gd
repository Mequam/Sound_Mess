extends "res://scripts/abstracts/projectile.gd"
func _ready():
	speed = 1600
func on_hit(col : KinematicCollision2D,delta : float)->void:
	.on_hit(col,delta)
	#remove ourselfs from the tree
	queue_free()
