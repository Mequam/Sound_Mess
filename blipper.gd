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
			dir =  target_pos - position
	return dir

func look_at(target_pos):
	if (target_pos.x < position.x):
		#this is a hack to flip the visuals and should not be used on kinimatic bodies
		get_node("Bunny").scale.x = -1
	else:
		get_node("Bunny").scale.x = 1
		
func move(target_pos):
	
	var dir = get_dir(target_pos)
	
	#we dont hapily sing while eeeevil
	if (mode =="normal"):
		play_dir(dir)
	
	look_at(target_pos)
	
	var collision = move_and_collide(Vector2(dir.x*20,dir.y*100))
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
				#musical mode not to be confused with AI mode
				get_node("NotePlayer").mode = 6

var beat = 0
#called every metronome beet
func _met_process():
	print(mode)
	match mode:
		"normal":
			if (beat == 3):
				get_node("Bunny/AnimationPlayer").play("Jump")
				get_node("NotePlayer").stop()
			if (beat == 4):
				get_node("Bunny/AnimationPlayer").play("Jump")
				get_node("NotePlayer").stop()
		"evil":
			print("evil_met")
			if (beat == 0.0):
				get_node("Bunny/AnimationPlayer").play("Idle_Evil_Beat_1")
				get_node("NotePlayer").play_note(3)
			elif (beat == 1.0):
				get_node("Bunny/AnimationPlayer").play("Idle_Evil_Beat_2")
				get_node("NotePlayer").play_note(4)
			elif (beat == 2.0):
				get_node("Bunny/AnimationPlayer").play("Idle_Evil_Beat_3")
				get_node("NotePlayer").play_note(1)
			else:
				get_node("NotePlayer").stop()
	beat += 1
	if (beat == 8):
		beat = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
