extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#this initial distance of the particles
var init_particle_dist = 0
var init_time = 1
var flip_h setget set_flip_h,get_flip_h
func set_flip_h(val):
	if (val and scale.x > 0):
		scale.x *= -1
	elif (!val and scale.x < 0):
		scale.x *= -1
func get_flip_h():
	return scale.x < 0
# Called when the node enters the scene tree for the first time.
func _ready():
	init_particle_dist = $Shrinking_Triangle.position.x
	init_time = $Shrinking_Triangle.speed_scale
func emit_horizontal(last_beat,sub_beat):
	if (sub_beat*last_beat != 0):
		$Shrinking_Triangle.speed_scale = init_time/last_beat
	$Shrinking_Triangle.rotation = -PI/2
	$Shrinking_Triangle.position = Vector2(init_particle_dist,0)
	$Shrinking_Triangle.emitting = true
func emit_down(last_beat,sub_beat):
	if (sub_beat*last_beat != 0):
		$Shrinking_Triangle.speed_scale = init_time/last_beat
	$Shrinking_Triangle.rotation = 0
	$Shrinking_Triangle.position = Vector2(0,init_particle_dist)
	$Shrinking_Triangle.emitting = true
func emit_up(last_beat,sub_beat):
	if (sub_beat*last_beat != 0):
		$Shrinking_Triangle.speed_scale = init_time/last_beat
	$Shrinking_Triangle.rotation = PI
	$Shrinking_Triangle.position = Vector2(0,-init_particle_dist)
	$Shrinking_Triangle.emitting = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
