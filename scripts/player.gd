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
			get_node("avatar").modulate = Color.lightgray
		else:
			get_node("avatar").modulate = Color.white
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
	#the avatar animates the direction that we move in
	var collided = move_and_collide(delta*dir*working_speed*100)
	$avatar.dir_anim(dir)
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
	proj.speed = speed/2
	get_tree().get_root().add_child(proj)

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
		var mult = 1
		if (rythom_score >= 1):
			#let the avatar decide what our flavors do
			mult=$avatar.run_flavor(flavor,to_move,delta)
		move_dir(to_move*mult,delta)
		flavor = -1

#decide what to do with the thing we hit
func collision_action(collision):
	print("struck " + str(collision) + " with i_timer of " + str(i_timer))
	if (!collision.collider.is_in_group("enemies") and collision.collider.has_method("on_col")):
		collision.collider.on_col(self,1)
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

#this function "augments" our next movement input with the given flavor
var flavor = -1 setget set_flavor, get_flavor
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
		set_flavor(6)
	if (Input.is_action_just_pressed("NOTE_0")):
		get_node("NotePlayer").play_note(-7)
	if (Input.is_action_just_pressed("NOTE_5")):
		#attack command
		get_node("NotePlayer").play_note(5-7)
		updateRythomMomentom()
		set_flavor(7)
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
func take_damage(amount):
	$health_bar.hp -= amount
	if $health_bar.hp == 0:
		hide()
#this is called by entities when they hit US
func on_col(thing,dmg=1):
	if (i_timer <= 0):
		#these only run if we are not invencible
		if (thing.is_in_group("enemies")):
			take_damage(dmg)

#this function plays when our sword interacts with a body
func _on_sword_strike(body):
	print("struck " + str(body))

func _ready():
	$health_bar.hp = 5
	$health_bar.sync_disp()
	get_node("NotePlayer").mode = 5
	#load all of our combos
	load_combos()
	#start our animation cylce
	$avatar.play_idle()
	
	#connect all of our child nodes
	get_node("ComboTracker").connect("combo_found",self,"on_combo")

func _process(delta):
	#this code snippet ensures that we play short blips
	if (get_node("NotePlayer").playing):
		timeout+=delta
		if (timeout >= .1):
			timeout = 0
			get_node("NotePlayer").stop()
	if (Input.is_action_just_pressed("NOTE_0")):
		take_damage(1)

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
