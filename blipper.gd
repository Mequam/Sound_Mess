extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mode = "normal" setget set_mode, get_mode
func get_mode():
	return mode
func set_mode(val):
	if (val == "evil"):
		get_node("Bunny/AnimationPlayer").play("Transform")
		mode = "still"
	elif (val in ["normal","evil_jump","still"]):
		mode = val
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Bunny/AnimationPlayer").connect("animation_finished",self,"_anim_finished")

var target
var go_down = true
func die():
	get_node("NotePlayer").play_note(0)
	get_parent().remove_child(self)
func play_dir(var dir):
	if (dir.x >= 0 and dir.y >= 0):
		get_node("NotePlayer").play_note(3)
	elif (dir.x >= 0 and dir.y < 0):
		get_node("NotePlayer").play_note(6)
	elif (dir.x < 0 and dir.y >= 0):
		get_node("NotePlayer").play_note(4)
	elif (dir.x < 0 and dir.y < 0):
		get_node("NotePlayer").play_note(1)

var rng = RandomNumberGenerator.new()
func get_dir(var target_pos):
	#gets the direction to move in based on the target position	
	var dir = Vector2(0,0)
	match mode:
		"normal":
			#hop left and right randomly
			dir = Vector2(rng.randf_range(-1,1),rng.randf_range(-2,2))
		"evil":
			dir =  make_dir(target_pos - position)
	return dir
#this function ensures that the magnitude of the given vector is 1
func make_dir(v2):
	var n = 1.0/sqrt(v2.x*v2.x+v2.y*v2.y)
	return Vector2(n*v2.x,n*v2.y)
func look_at(target_pos):
	if (target_pos.x < position.x):
		#this is a hack to flip the visuals and should not be used on kinimatic bodies
		get_node("Bunny").scale.x = -1
	else:
		get_node("Bunny").scale.x = 1
func on_col(thing):
	print("hit")
	if (vulnerable and thing.i_timer != null and thing.i_timer != 0):
		queue_free()
func move(target_pos):
	
	var dir = get_dir(target_pos)
	
	#we dont hapily sing while eeeevil
	if (mode =="normal"):
		play_dir(dir)
	
	look_at(target_pos)
	
	var collision = move_and_collide(Vector2(dir.x,dir.y)*(position.distance_to(target_pos)/4))
	if (collision and collision.collider.has_method("on_col")):
		#tell the thing that we collided with that we have a hit
		collision.collider.on_col(self)
	

#this function moves the bunny after it finishes its animation
func _anim_finished(var animation):
	match mode:
		"normal":
			if (animation == 'Jump'):
				move(target)
				get_node("Bunny/AnimationPlayer").play("Idle")
			else:
				get_node("Bunny/AnimationPlayer").play("Jump")
		"still":
			if (animation == "Transform"):
				mode = "evil"
				add_to_group("enemies")
				#musical mode not to be confused with AI mode
				get_node("NotePlayer").mode = 5

var beat = 0
var vulnerable = true
#called every metronome beet
func run(target_pos,beat):
	target=target_pos
	match mode:
		"normal":
			if (beat == 3.0):
				get_node("Bunny/AnimationPlayer").play("Jump")
				get_node("NotePlayer").stop()
			if (beat == 4.0):
				get_node("Bunny/AnimationPlayer").play("Jump")
				get_node("NotePlayer").stop()
		"evil":
			if (position.distance_to(target) > 350):
				if (beat == 0.0):
					get_node("Bunny/AnimationPlayer").play("Idle_Evil_Beat_1")
					get_node("NotePlayer").play_note(1)
				elif (beat == 1.0):
					get_node("Bunny/AnimationPlayer").play("Idle_Evil_Beat_2")
					get_node("NotePlayer").play_note(2)
				elif (beat == 2.0):
					get_node("Bunny/AnimationPlayer").play("Idle_Evil_Beat_3")
					get_node("NotePlayer").play_note(4)
				else:
					get_node("NotePlayer").stop()
			else:
				if (beat == 0.0):
					collision_mask  = pow(2,3) + pow(2,4)
					get_node("Bunny/AnimationPlayer").play("Idle_Evil_Beat_1")
					get_node("NotePlayer").play_note(2)
				elif (beat == 1.0):
					#we are vulnerable on our prep
					vulnerable = true
					#make sure that the player can hit us
					collision_mask  = pow(2,0) + pow(2,1) + pow(2,3) + pow(2,4)
					
					get_node("Bunny/AnimationPlayer").play("Evil_Jump_Prep")
					get_node("NotePlayer").play_note(7)
				elif (beat == 2.0):
					vulnerable = false
					collision_mask = pow(2,3) + pow(2,4)
					get_node("Bunny/AnimationPlayer").play("Evil_Jump_Action")
					get_node("NotePlayer").play_note(6)
				elif ( 2.5 <= beat and beat <= 3.0):
					get_node("NotePlayer").stop()
					move(target)
				elif (beat == 4.0):
					get_node("Bunny/AnimationPlayer").play("Evil_Land")
					get_node("NotePlayer").play_note(5-7)
					collision_mask  = pow(2,0) + pow(2,1) + pow(2,3) + pow(2,4)
					var collision = move_and_collide(Vector2(0,0))
					if (collision and collision.collider.has_method("on_col")):
						collision.collider.on_col(self)
						
				elif (beat):
					get_node("NotePlayer").stop()
	beat += .5
	if (beat == 5.0):
		beat = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
