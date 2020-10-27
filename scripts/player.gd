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

#determines the type of input that the game is looking for
#options are dev (uses keys 1-7) and midi (uses midi note frequency)


#TODO: this needs a setter and a getter that changes other aspects of the game
#additionaly need to add the fourier transform or "tuner" input method
var input_mode = "dev"

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

func check_action(act):
	match input_mode:
		"dev":
			return Input.is_action_just_pressed(act)
		"midi":
			return Globals.action_just_pressed(act)
		_:
			return false
#checks the inputs for the movement of the object
func move_2d(delta,input_number,flavor):
	var to_move = Vector2(0,0)
	match input_number:
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
			#mult=$avatar.run_flavor(flavor,to_move,delta)
		move_dir(to_move*mult,delta)
		$avatar.clean_flavor(flavor,to_move,delta)

#decide what to do with the thing we hit
func collision_action(collision):
	if (!collision.collider.is_in_group("enemies") and collision.collider.has_method("on_col")):
		collision.collider.on_col(self,1)

#this function takes a vector 2 and sets the player up for attacking
func attack(dir):
	if (dir.x > 0):
		get_node("Player_Sprite").flip_h = false
		get_node("Player_Sprite/AnimationPlayer").play("Attack")
	elif (dir.x < 0):
		get_node("Player_Sprite").flip_h = true
		get_node("Player_Sprite/AnimationPlayer").play("Attack")

func make_dir(v2):
	var n = 1.0/sqrt(v2.x*v2.x+v2.y*v2.y)
	return Vector2(n*v2.x,n*v2.y)
var flavor = -1 setget set_flavor,get_flavor
func set_flavor(new_flavor):
	flavor = new_flavor
	$avatar.flavor_changed(flavor)
func get_flavor():
	return flavor
func getActionId():
	for i in range(0,8):
		if (check_action("NOTE_" + str(i))):
			return i
	return -1

#this function checks which input the user pressed and passes that information to the players other movement functions
func find_input(delta):
			var i = getActionId()
			if i != -1:
				var tmpFlavor = run_flavor_input(delta,i)
				if (tmpFlavor == -2):
					move_2d(delta,i,flavor)
					set_flavor(-1)
				else:
					set_flavor(tmpFlavor)
				#check to see if the player is performing a combo
				#get_node("ComboTracker").check_inputs(delta)

#this function checks the given inputs to move the player and sets the flavor accordingly
func run_flavor_input(delta,input_number):
	#make sure that the player is moving in time
	updateRythomMomentom()
	
	var flavor = -1
	match input_number:
		0:
			get_node("NotePlayer").play_note(-7)
		7:
			get_node("NotePlayer").play_note(0)
		6:
			flavor = 6
			get_node("NotePlayer").play_note(-1)
		5:
			flavor = 7
			get_node("NotePlayer").play_note(5-7)
		_:
			#indicates that we did nothing and want to move the character
			flavor = -2
	$avatar.flavor_changed(flavor)
	return flavor

	
#runs when the player completes a combo
func on_combo(combo_name):
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
#used to make the player invencible
var invencible = false
#this is called by entities when they hit US
func on_col(thing,dmg=1):
	if (i_timer <= 0 and !invencible):
		#these only run if we are not invencible
		if (thing.is_in_group("enemies")):
			take_damage(dmg)

#this function plays when our sword interacts with a body
func _on_sword_strike(body):
	print("struck " + str(body))

#this can be thought of as the actual ready function, we do this
#so we can over-ride the function isntead of stacking behavior
func main_ready():
	$health_bar.hp = 5
	$health_bar.sync_disp()
	get_node("NotePlayer").mode = 5
	#start our animation cylce
	$avatar.play_idle()
	
	#connect all of our child nodes
	#get_node("ComboTracker").connect("combo_found",self,"on_combo")
	add_to_group("player")

func _ready():
	main_ready()
	$avatar.load_avatar()
#this functio is called to make sure that the note player is playing or ONE blip
func limitNotePlayerTime(delta):
		#this code snippet ensures that we play short blips
	if (get_node("NotePlayer").playing):
		timeout+=delta
		if (timeout >= .1):
			timeout = 0
			get_node("NotePlayer").stop()
func main_process(delta):
		#check the user inputs and act accordingly
	find_input(delta)
	#make sure the note player does not play forever
	limitNotePlayerTime(delta)
#for whatever reason _process does not get over-wridden in gdscript
#so we create a main_process to do that for us
func _process(delta):
	main_process(delta)


#this function is called every beat of the metronome
func _met_process(beat):
	if (i_timer != 0):
		#decriment our invencibility timer
		set_i_timer(i_timer - 1)
