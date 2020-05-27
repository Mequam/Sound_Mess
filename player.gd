extends KinematicBody2D

var speed = 50
#timer used to tur off the notes that are playing
var timeout = 0
var long = false

func dir_anim(dir):
	#plays the proper animation for moving in the given direction
	if (dir.x > 0):
		get_node("Player_Sprite").flip_h = false
		get_node("Player_Sprite/AnimationPlayer").play("Slide")
	elif (dir.x < 0):
		#trick the node into playing its animation backwords
		get_node("Player_Sprite").flip_h = true
		get_node("Player_Sprite/AnimationPlayer").play("Slide")

#checks the inputs for the movement of the object
func move_2d(delta):
	var to_move = Vector2(0,0)
	if (Input.is_action_just_pressed("NOTE_4")):
		get_node("NotePlayer").play_note(4)
		to_move.x += 1
	if (Input.is_action_just_pressed("NOTE_1")):
		get_node("NotePlayer").play_note(1)
		to_move.x -= 1
	if (Input.is_action_just_pressed("NOTE_2")):
		get_node("NotePlayer").play_note(2)
		to_move.y += 1
	if (Input.is_action_just_pressed("NOTE_3")):
		get_node("NotePlayer").play_note(3)
		to_move.y -= 1
	if (to_move != Vector2(0,0)):
		var working_speed = speed
		if (long):
			working_speed /= 2
			long = !long
		dir_anim(to_move)
		var collided = move_and_collide(delta*to_move*working_speed*100)
		if (collided):
			#decide what to do with the thing that we hit
			collision_action(collided)
func collision_action(collision):
	#decide what to do with the thing we hit
	collision.collider.on_col(self)
func check_inputs(delta):
	if (Input.is_action_just_pressed("mode_change")):
		get_node("NotePlayer").mode+=1
	if (Input.is_action_just_pressed("NOTE_6")):
		get_node("NotePlayer").play_note(6)
		long = true
	if (Input.is_action_just_pressed("NOTE_0")):
		get_node("NotePlayer").play_note(0)
	if (Input.is_action_just_pressed("NOTE_4")):
		get_node("NotePlayer").play_note(4)
	move_2d(delta)
	
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
func on_col(thing):
	if (thing.is_in_group("spiders")):
		queue_free()
# Called when the node enters the scene tree for the first time.
func _ready():
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
#end song of the spiders left	
	#connect all of our child nodes
	get_node("ComboTracker").connect("combo_found",self,"on_combo")
	get_node("Player_Sprite/AnimationPlayer").connect("animation_finished",self,"_finished_anim")

func _finished_anim(anim):
	get_node("Player_Sprite/AnimationPlayer").play("Idle")

func _process(delta):
	if (get_node("NotePlayer").playing):
		timeout+=delta
		if (timeout >= .1):
			timeout = 0
			get_node("NotePlayer").stop()
