extends "res://scripts/abstracts/generic_area.gd"
func _on_poof_grass_body_entered(body):
	$tall_grass/Particles2D.emitting = true
