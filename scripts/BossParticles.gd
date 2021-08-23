extends Node2D

signal death
signal arrived
signal out_of_cam

#the direction we move
var flight_dir : Vector2 = Vector2(0,-1)
var target_dir setget set_target_dir,get_target_dir
func set_target_dir(val):
	if typeof(val) == TYPE_VECTOR2:
		flight_dir = ((val as Vector2)-position).normalized()
	else:
		flying = false
	target_dir = val
func get_target_dir():
	return target_dir
#whether or not we are flying
var flying : bool = false

func _ready():
	if not flying:
		$AnimationPlayer.play("FlyUp")
	else:
		$AnimationPlayer.play("Flying")
func die_with_particles():
	var particles = load("res://scenes/assets/BossParticleExplosion.tscn")
	var part = particles.instance()
	part.position = position
	get_parent().add_child(part)
	#actually start the particles emiting
	part.get_node("AnimationPlayer").play("Timing")
	queue_free()
	
func queue_free():
	emit_signal("death")
	.queue_free()
var speed = 1.0
var accel = 400.0
var top_speed = 800.0

func _process(delta):
	if flying:
		if typeof(target_dir) == TYPE_VECTOR2 and (target_dir as Vector2).distance_squared_to(global_position + flight_dir*speed*delta) > (target_dir as Vector2).distance_squared_to(global_position):
			flying = false
			emit_signal("arrived")
		else:
			global_position += flight_dir*speed*delta
			if speed < top_speed:
				speed += accel*delta
func _on_AnimationPlayer_animation_finished(anim_name):
	flying = true
func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("out_of_cam")
