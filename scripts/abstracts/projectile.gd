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

#the code that lets the projectile fly
var flying : bool setget set_flying,get_flying
func set_flying(val : bool)->void:
	var fly = get_flying()
	#we should be flying and are not currently
	if val and not fly:
		#the sprite is high when we fly
		$Sprite.position = initial_pos+Vector2(0,-400)
		#set the collision to the default collision layer, shifted into the flight zone
		collision_layer = col_math.shift_collision(gen_col_layer(),col_math.SuperLayer.FLIGHT)
		collision_mask = col_math.shift_collision(gen_col_mask(),col_math.SuperLayer.FLIGHT)
	#we should not be flying
	elif not val:
		#reset the collision to be on the normal layer
	#	$Sprite.position = initial_pos
		collision_layer = gen_col_layer()
		collision_mask = gen_col_mask()
func get_flying()->bool:
	return col_math.in_layer_no_constants(
		collision_layer,
		col_math.shift_collision(gen_col_layer(),col_math.SuperLayer.FLIGHT))

var initial_pos : Vector2
#TODO: it might be worth it to create a generalized projectile
#class
func _ready():
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
		$Sprite.rotation += dir.angle()
		initial_pos = $Sprite.position
	if $RotatingColShape:
		$RotatingColShape.rotation += dir.angle()
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
