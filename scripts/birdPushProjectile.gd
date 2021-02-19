extends "res://scripts/abstracts/generic_kinematic.gd"
var particles = preload("res://scenes/assets/bird_dust_particles.tscn")
var speed : float = 800.0
var dir : Vector2 = Vector2(1,0)
#we hit enemies
func gen_col_mask() -> int:
	return col_math.Layer.ENEMY
#nothing hits us
func gen_col_layer()->int:
	return 0
func _ready():
	add_to_group("projectile")
	
	var inst = particles.instance()
	inst.position = position
	inst.emit_dir(dir)
	get_parent().add_child(inst)
	
	collision_layer = gen_col_layer()
	collision_mask = gen_col_mask()
var elapsed_time : float = 0
func _process(delta):
	var col : KinematicCollision2D = move_and_collide(dir*speed*delta)
	if col:
		col.collider.move_and_collide(dir*speed*delta*2.0)
	elapsed_time+=delta
	print("[push_particles] " + str(elapsed_time))
	if elapsed_time >= 0.77:
		queue_free()
