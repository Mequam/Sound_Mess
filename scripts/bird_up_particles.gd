extends Node2D
var emitting : bool setget set_emitting,get_emitting
func set_emitting(val : bool):
	if val:
		$top_right.emit_dir(Vector2(1,0))
		$bottom_left.emit_dir(Vector2(-1,0))
func get_emitting():
	return $top_right/flight_dust_up_down.emitting
