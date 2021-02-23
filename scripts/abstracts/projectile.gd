extends "res://scripts/abstracts/generic_kinematic.gd"
#called when we are removed from the game
signal despawn
#called when we collide with an object
signal hit


var speed : float = 800.0
var dir : Vector2 = Vector2(1,0)
#by default all projectiles hit enemies
func gen_col_mask() -> int:
	return col_math.Layer.ENEMY
#nothing hits us
func gen_col_layer()->int:
	return 0

#TODO: it might be worth it to create a generalized projectile
#class
func _ready():
	collision_layer = gen_col_layer()
	collision_mask = gen_col_mask()
	add_to_group("projectile")
	#add particles at spawn if we have them
	if $spawn_particles != null:
		var particle_ref = $spawn_particles
		remove_child(particle_ref)
		var parent = get_parent()
		particle_ref.owner = parent
		particle_ref.position = position
		parent.add_child(particle_ref)
		
		particle_ref.emit_dir(dir)
	#rotate the main sprite if we have it
	if $Sprite:
		$Sprite.rotation_degrees = dir.angle()
#called when we collide with an entity, inteanded to be overriden by the child class
func on_hit(col : KinematicCollision2D,delta : float) -> void:
	emit_signal("hit",col)
func queue_free():
	emit_signal("despawn")
	.queue_free()
func _process(delta):
	var col : KinematicCollision2D = move_and_collide(dir*speed*delta)
	if col:
		on_hit(col,delta)
