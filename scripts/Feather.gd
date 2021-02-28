extends "res://scripts/abstracts/projectile.gd"
func _ready():
	speed = 1600
func on_hit(col : KinematicCollision2D,delta : float)->void:
	if col.collider.has_method("take_damage"):
		var dmg : int = 1
		if get_flying():
			dmg = 2
		col.collider.take_damage(dmg)
	.on_hit(col,delta)
	#remove ourselfs from the tree
	queue_free()
