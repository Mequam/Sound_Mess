extends "res://scripts/abstracts/pushProjectile.gd"

const MAX_TIME : float = 0.2
var elapsed_time : float = 0
var initial_position : Vector2
func _ready():
	initial_position = position
func _process(delta):
	if elapsed_time >= MAX_TIME or initial_position.distance_squared_to(position) > 160000:
		queue_free()
	elapsed_time += delta
