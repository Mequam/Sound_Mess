extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Bunny/AnimationPlayer").connect("animation_finished",self,"move_after_jump")
	#get_node("Bunny/AnimationPlayer").play("Idle")
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

func get_dir(var target_pos):
	#gets the direction to move in based on the target position	
	var dir = Vector2(0,0)
	#set up the x position
	if (target_pos.x < self.position.x):
		#move to the left
		dir.x = -1
	else:
		dir.x = 1
	#set up the y position
	if (go_down):
		dir.y = -1
	else:
		dir.y = 1

	#we alternate between going up and down	
	go_down = !go_down
	
	return dir
func look_at(target_pos):
	if (target_pos.x < position.x):
		#this is a hack to flip the visuals and should not be used on kinimatic bodies
		get_node("Bunny").scale.x = -1
	else:
		get_node("Bunny").scale.x = 1
		
func move(target_pos):
	var dir = get_dir(target_pos)
	play_dir(dir)
	move_and_collide(Vector2(dir.x*20,dir.y*100))
	look_at(target_pos)

#this function moves the bunny after it finishes its animation
func move_after_jump(var animation):
	if (animation == 'Jump'):
		move(target)
		get_node("Bunny/AnimationPlayer").play("Idle")
	else:
		get_node("Bunny/AnimationPlayer").play("Jump")
var beat = 0
func move_to_player():
	if (beat == 3):
		get_node("Bunny/AnimationPlayer").play("Jump")
		get_node("NotePlayer").stop()
	if (beat == 4):
		get_node("Bunny/AnimationPlayer").play("Jump")
		get_node("NotePlayer").stop()
	beat += 1
	if (beat == 8):
		beat = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
