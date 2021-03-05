extends Node2D
func emit_dir(dir : Vector2)->void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			$flight_dust_left_right.scale.x = 1
		else:
			$flight_dust_left_right.scale.x = -1
		$flight_dust_left_right.emitting = true	
	else:
		if dir.y > 0:
			$flight_dust_up_down.scale.y = 1
		else:
			$flight_dust_up_down.scale.y = -1
		$flight_dust_up_down.emitting = true
func _process(delta):
	#remove us from the tree if we are done emitting
	if (not $flight_dust_left_right.emitting and not $flight_dust_up_down.emitting):
		queue_free()
