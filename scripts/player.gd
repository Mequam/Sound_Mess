extends KinematicBody2D

var speed = 10
#timer used to turn off the notes that are playing
var timeout = 0
var long = false
#the time offset of the smallest possible sub beat, calculated from a bellow function
var sub_beat
#the time of the players last input, stored to calculate rythom
var last_input = 0
var i_timer = 0 setget set_i_timer, get_i_timer
var mode = 1

#var shrinking_triangle = load("res://Shrinking_Triangle.tscn")

func set_i_timer(val):
	if (val >= 0):
		i_timer = val
		if (val != 0):
			get_node("Player_Sprite").modulate = Color.lightgray
		else:
			get_node("Player_Sprite").modulate = Color.white
func get_i_timer():
	return i_timer
#used to score how well we are keeping track of rythom
var rythom_score = 0 setget set_rythom_score,get_rythom_score

func set_rythom_score(val):
	rythom_score = val
func get_rythom_score():
	return rythom_score

#this function retrives a given speed based on our rythom score
func RythomToSpeed():
	if (rythom_score < 1):
		return 5
	elif (rythom_score < 2):
		return  30
	elif (rythom_score < 3):
		return 60
	else:
		return 60

#plays the proper animation for moving in the given direction
func dir_anim(dir):
	if (dir.y < 0):
		#emit up
		$Player_Sprite.emit_up(last_beat,sub_beat)
	elif (dir.y > 0):
		#emit down
		$Player_Sprite.emit_down(last_beat,sub_beat)
	else:
		$Player_Sprite.emit_horizontal(last_beat,sub_beat)
		if (dir.x > 0):
			get_node("Player_Sprite").flip_h = false
			get_node("Player_Sprite/AnimationPlayer").play("Slide")
		elif (dir.x < 0):
			#trick the node into playing its animation backwords
			get_node("Player_Sprite").flip_h = true
			get_node("Player_Sprite/AnimationPlayer").play("Slide")

#this function checks wether or not the given delta beat falls close enough to our sub beats to be valid
func checkInputRythom():
	var new_input = OS.get_system_time_msecs()
	var delta = (new_input - last_input)/1000.0
	last_input = new_input

	for i in range(1,3):
		#check to see if the note distance goes through 16th notes
		var target = sub_beat*pow(2,i)
		var beat_err = target/6
		#print("checking " + str(delta) + " == "  + str(target) +    "+- " + str(beat_err))
		if (target-beat_err <= delta and delta <= target+beat_err):
			#print("in time with " + str(i))
			return i
	return -100

#stores the last beat that the player played
var last_beat = 0
func get_type():
	return "player"
#this fuction updates our momentom to match our rythom
func updateRythomMomentom():
	var beat_value = checkInputRythom()
	if (beat_value != -100):
		last_beat = beat_value
		rythom_score += 1
		if (beat_value == 2):
			#they are in quarter notes, give them two beats of invulnerability
			i_timer = 4
	else:
		rythom_score -= 2
	if (rythom_score < -2):
		rythom_score = -2
	if (rythom_score > 4):
		rythom_score = 4

#this function moves us in the given direction for player control
func move_dir(dir,delta):
	var working_speed = RythomToSpeed()
	dir_anim(dir)
	var collided = move_and_collide(delta*dir*working_speed*100)
	if (collided):
		#decide what to do with the thing that we hit
		collision_action(collided)
var push_proj_package = load("res://scenes/instance/projectiles/pushProjectile.tscn")

#this function is in charge of our push effect
func push_dir(dir,delta):
	var proj = push_proj_package.instance()
	proj.beat_val = last_beat
	proj.dialate_speed(sub_beat)
	proj.dir = dir
	#TODO: figure out why this position needs to be shifted! (without the shift the projectile spawns in the wrong spot DESPITE beign at 0,0 in our chords)
	proj.position = position+Vector2(105,0)
	print("spawning projctile @ " + str(proj.position-position) + " with last beat of " + str(last_beat))
	proj.speed = speed/2
	get_tree().get_root().add_child(proj)
	for node in get_tree().get_nodes_in_group("projectile"):
		print("global position "  + str(node.position - position))

#checks the inputs for the movement of the object
func move_2d(delta):
	var to_move = Vector2(0,0)
	for i in range(1,5):
		if (Input.is_action_just_pressed("NOTE_" + str(i))):
			updateRythomMomentom()
			match i:
				4:
					get_node("NotePlayer").play_note(4-7)
					to_move.x += 1
				1:
					get_node("NotePlayer").play_note(1-7)
					to_move.x -= 1
				2:
					get_node("NotePlayer").play_note(2-7)
					to_move.y += 1
				3:
					get_node("NotePlayer").play_note(3-7)
					to_move.y -= 1
	if (to_move != Vector2(0,0)):
		if (rythom_score >= 1):
			#we only match flavor when the rythom score is valid
			match flavor:
				"push":
					push_dir(to_move,delta)
					move_dir(to_move/2,delta)
				"attack":
					attack_dir(to_move,delta)
				"none":
					move_dir(to_move,delta)
				_:
					move_dir(to_move,delta)
		else:
			move_dir(to_move,delta)
		flavor = "none"

#decide what to do with the thing we hit
func collision_action(collision):
	print("struck " + str(collision) + " with i_timer of " + str(i_timer))
	if (!collision.collider.is_in_group("enemies") and collision.collider.has_method("on_col")):
		collision.collider.on_col(self)
	else:
		hide()

#this function takes a vector 2 and sets the player up for attacking
func attack(dir):
	print("[DEBUG] attacking!")
	if (dir.x > 0):
		get_node("Player_Sprite").flip_h = false
		get_node("Player_Sprite/AnimationPlayer").play("Attack")
	elif (dir.x < 0):
		get_node("Player_Sprite").flip_h = true
		get_node("Player_Sprite/AnimationPlayer").play("Attack")

func make_dir(v2):
	var n = 1.0/sqrt(v2.x*v2.x+v2.y*v2.y)
	return Vector2(n*v2.x,n*v2.y)

var attack_dir_pkg = load("res://scenes/instance/projectiles/attack_proj.tscn")

#this function is in charge of our push effect
func attack_dir(dir,delta):
	var proj = attack_dir_pkg.instance()
	proj.scale *= last_beat
	proj.speed = 400*last_beat
	proj.dir = dir
	if (last_beat == 2):
		proj.modulate = Color.lightgray
	var offset = make_dir(dir)*30
	#this creates a dead zone around the player sprite so that the projectile never touches them
	if (offset.x < 10 and offset.x > -10 and offset.y < 30 and offset.y > -40):
		if (offset.y-30 > offset.y+60):
			offset.y = 30
		else:
			offset.y = -60
	proj.position = position + Vector2(114,-25) + offset
	proj.position
	get_tree().get_root().add_child(proj)

#this function "augments" our next movement input with the given flavor
var flavor = "none" setget set_flavor, get_flavor
func set_flavor(new_flavor):
	flavor = new_flavor
func get_flavor():
	return flavor

#this function checks the given inputs to move the player
func check_inputs(delta,delta_beat):
	if (Input.is_action_just_pressed("mode_change")):
		get_node("NotePlayer").mode+=1
	
	if (Input.is_action_just_pressed("NOTE_6")):
		#attack right
		get_node("NotePlayer").play_note(6-7)
		updateRythomMomentom()
		set_flavor("push")
	if (Input.is_action_just_pressed("NOTE_0")):
		get_node("NotePlayer").play_note(-7)
	if (Input.is_action_just_pressed("NOTE_5")):
		#attack command
		get_node("NotePlayer").play_note(5-7)
		updateRythomMomentom()
		set_flavor("attack")
	if (Input.is_action_just_pressed("NOTE_7")):
		get_node("NotePlayer").play_note(0)
	move_2d(delta)
	get_node("ComboTracker").check_inputs(delta)
	
#runs when the player completes a combo
func on_combo(combo_name):
	print('[player] found combo ' + combo_name)
	match combo_name:
		"half_step_release" :
			get_node("Player_Sprite").scale.x *= -1
			get_node("Player_Sprite").scale.y *= -1
		"full_scale" :
			get_node("NotePlayer").mode += 1
		"song of the spiders right":
			for node in get_tree().get_nodes_in_group("spiders"):
				if (node.position.x > position.x and node.position.distance_to(position) <= 800):
					if (node.just_attacked):
						node.mode = "die"
		"song of the spiders left":
			for node in get_tree().get_nodes_in_group("spiders"):
				if (node.position.x < position.x and node.position.distance_to(position) <= 800):
					if (node.just_attacked):
						node.mode = "die"

#this is called by entities when they hit US
func on_col(thing):
	#print("i_timer " + str(i_timer))
	#print("hit by " + thing.name)
	if (i_timer <= 0):
		#these only run if we are not invencible
		if (thing.is_in_group("enemies")):
			hide()

#this function plays when our sword interacts with a body
func _on_sword_strike(body):
	print("struck " + str(body))

func _ready():
	get_node("NotePlayer").mode = 5
	#load all of our combos
	load_combos()
	#start our animation cylce
	get_node("Player_Sprite/AnimationPlayer").play("Idle")
	
	#connect all of our child nodes
	get_node("ComboTracker").connect("combo_found",self,"on_combo")
	get_node("Player_Sprite/AnimationPlayer").connect("animation_finished",self,"_finished_anim")

#this runs whenever our animation player finishes
#we use it to reset to an idle state
func _finished_anim(anim):
	get_node("Player_Sprite/AnimationPlayer").play("Idle")

func _process(delta):
	#this code snippet ensures that we play short blips
	if (get_node("NotePlayer").playing):
		timeout+=delta
		if (timeout >= .1):
			timeout = 0
			get_node("NotePlayer").stop()

#this function is called every beat of the metronome
func _met_process(beat):
	if (i_timer != 0):
		#decriment our invencibility timer
		set_i_timer(i_timer - 1)
#this function is in charge of loading the combos for our player
func load_combos():
		#start mortal combat combo
	var forward = get_node("ComboTracker").comboActionScript.new()
	forward.action = "NOTE_1"
	forward.falling = false
	var forward2 = get_node("ComboTracker").comboActionScript.new()
	forward2.action = "NOTE_1"
	forward2.falling = true
	forward2.delta = .1
	
	var forward3 = get_node("ComboTracker").comboActionScript.new()
	forward3.action = "NOTE_1"
	forward3.falling = false
	forward3.delta = .1
	var forward4 = get_node("ComboTracker").comboActionScript.new()
	forward4.action = "NOTE_1"
	forward4.falling = true
	forward4.delta = .1
	
	var forward5 = get_node("ComboTracker").comboActionScript.new()
	forward5.action = "NOTE_6"
	forward5.falling = false
	forward5.delta = .1
	
	var c = get_node("ComboTracker").comboContainerScript.new()
	c.name = "mortal"
	c.action_list = [forward,forward2,forward3,forward4,forward5]
	
	get_node("ComboTracker").combos.append(c)
	#end mortal combat combo
	#start half step release combo
	var cmbAct = get_node("ComboTracker").comboActionScript.new()
	cmbAct.falling = false
	cmbAct.action = "NOTE_6"
	
	var cmbAct_2 = get_node("ComboTracker").comboActionScript.new()
	cmbAct_2.falling = true
	cmbAct_2.action="NOTE_6"
	cmbAct_2.delta = .1
	
	var cmbAct_3 = get_node("ComboTracker").comboActionScript.new()
	cmbAct_3.falling = false
	cmbAct_3.action="NOTE_0"
	cmbAct_3.delta = .1
	
	var cmbContainer = get_node("ComboTracker").comboContainerScript.new()
	
							#note1 a beat later release and start note 6
	cmbContainer.action_list = [cmbAct,cmbAct_2,cmbAct_3]
	cmbContainer.name = "half_step_release"
	
	get_node("ComboTracker").combos.append(cmbContainer)
	#end half step release combo
	
	#start full scale combo
	var container = get_node("ComboTracker").comboContainerScript.new()
	
	
	#set up the initial point
	var point1 = get_node("ComboTracker").comboActionScript.new()
	point1.action = "NOTE_0"
	point1.falling = false
	point1.plus_err = 1
	point1.minus_err = 1
	
	var point2 = get_node("ComboTracker").comboActionScript.new()
	point2.action = "NOTE_0"
	point2.falling = true
	point2.delta = .1
	point2.plus_err = 1
	point2.minus_err = 1
	
	container.action_list = [point1,point2]
	for i in range(1,6):
		#set up the remaining points
		var rising_point = get_node("ComboTracker").comboActionScript.new()
		rising_point.delta = .1
		rising_point.action = "NOTE_" + str(i)
		rising_point.falling = false
		rising_point.plus_err = 1
		rising_point.minus_err = 1
		
		var falling_point = get_node("ComboTracker").comboActionScript.new()
		falling_point.delta = .1
		falling_point.action = "NOTE_" + str(i)
		falling_point.falling = true
		falling_point.plus_err = 1
		falling_point.minus_err = 1
		#add them to the combo
		container.action_list.append(rising_point)
		container.action_list.append(falling_point)
	
	container.name = "full_scale"
	for action in container.action_list:
		print(action.action + ' ' + str(action.falling))
	get_node("ComboTracker").combos.append(container)
	#end scale combo
	
#start combo song of the spider right
	var initial_point = get_node("ComboTracker").comboActionScript.new()
	initial_point.falling = false
	initial_point.action="NOTE_1"

	var initial_point_fall = get_node("ComboTracker").comboActionScript.new()
	initial_point_fall.falling = true
	initial_point_fall.action="NOTE_1"
	initial_point_fall.delta = .5
	
	var second_point = get_node("ComboTracker").comboActionScript.new()
	second_point.falling = false
	second_point.action="NOTE_4"
	second_point.delta = .5
	
	var second_point_fall = get_node("ComboTracker").comboActionScript.new()
	second_point_fall.falling = true
	second_point_fall.action="NOTE_4"
	second_point_fall.delta = .5
	
	var thrid_point = get_node("ComboTracker").comboActionScript.new()
	thrid_point.falling = false
	thrid_point.action="NOTE_5"
	thrid_point.delta = .5
	
	var thrid_point_fall = get_node("ComboTracker").comboActionScript.new()
	thrid_point_fall.falling = true
	thrid_point_fall.action="NOTE_5"
	thrid_point_fall.delta = .5
	
	var cmb_container = get_node("ComboTracker").comboContainerScript.new()
	
	cmb_container.action_list = [initial_point,initial_point_fall,second_point,second_point_fall,thrid_point,thrid_point_fall]
	cmb_container.name = "song of the spiders right"
	get_node("ComboTracker").combos.append(cmb_container)
#end song of the spiders right
#start song of the spiders left
	var left_initial_point = get_node("ComboTracker").comboActionScript.new()
	left_initial_point.falling = false
	left_initial_point.action="NOTE_2"

	var left_initial_point_fall = get_node("ComboTracker").comboActionScript.new()
	left_initial_point_fall.falling = true
	left_initial_point_fall.action="NOTE_2"
	left_initial_point_fall.delta = .5
	
	var left_cmb_container = get_node("ComboTracker").comboContainerScript.new()
	
	left_cmb_container.action_list = [left_initial_point,left_initial_point_fall]
	#steal the remaining points from the right song of the spider combo
	for i in range(2,len(cmb_container.action_list)-1):
		left_cmb_container.action_list.append(cmb_container.action_list[i])
	left_cmb_container.name = "song of the spiders left"
	get_node("ComboTracker").combos.append(left_cmb_container)
