extends "res://scripts/abstracts/spawn_particles.gd"
var flying : bool setget set_flying,get_flying
func set_flying(val : bool)->void:
	if val and not flying:
		$particles.position += Vector2(0,-400)
	elif not val and flying:
		$particles.position -= Vector2(0,-400)
func get_flying()->bool:
	return $particles.position.y < -400
func emit_dir(dir : Vector2):
	$particles.process_material.set_direction(Vector3(dir.x,dir.y,0.0))
	.emit_dir(dir)
