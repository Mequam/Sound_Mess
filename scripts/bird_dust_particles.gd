extends Node2D
func emit_dir(dir : Vector2)->void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			$flight_dust.scale.x = 1
		else:
			$flight_dust.scale.x = -1
		$flight_dust.emitting = true	
