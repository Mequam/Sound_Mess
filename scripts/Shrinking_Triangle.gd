extends Particles2D

#emits twords the given direction
func emit_dir(dir):
	rotation = create_rot(dir)
	emitting = true
#this function takes a given direction and returns the angle we want to emit at
func create_rot(dir):
	var neg = 1 if dir.y >= 0 else -1
	return acos(dir.x)*neg-PI/2
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
	init_particle_dist = position.distance_to(get_parent().position)
	print("initial partical distance of " + str(init_particle_dist))
	init_time = speed_scale
func _init():
	init_time = speed_scale
#sets the speed based on the previous beats given by the player
func dialate_speed(last_beat,sub_beat):
	if (sub_beat*last_beat != 0):
		speed_scale = init_time/last_beat

#emits in the specified direction
func emit_left():
	rotation = -PI/2
	emitting = true	
func emit_right():
	rotation = PI/2
	emitting = true
func emit_down():
	rotation = 0
	emitting = true
func emit_up():
	rotation = PI
	emitting = true

#moves the particles to the position and emits
func emit_dir_pos(dir):
	position = -dir*init_particle_dist
	print("moving to " + str(position))
	emit_dir(dir)
