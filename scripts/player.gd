extends "res://scripts/abstracts/entity.gd"

#timer used to turn off the notes that are playing
var timeout = 0

#the time offset of the smallest possible sub beat, calculated from a bellow function
var sub_beat

#the time of the players last input, stored to calculate rythom
var last_input = 0

#this is from legacy code, it is short for invencibility timer
#TODO: this needs to either be further supported or removed from the game
var i_timer = 0 setget set_i_timer, get_i_timer
func set_i_timer(val):
	if (val >= 0):
		i_timer = val
		if (val != 0):
			get_node("avatar").modulate = Color.lightgray
		else:
			get_node("avatar").modulate = Color.white
func get_i_timer():
	return i_timer

#makes the player talk and unable to stop talking
var _permatalk = false setget set_perm_talk,get_perm_talk
func set_perm_talk(val : bool):
	_permatalk = val
	$SpeechBubble.visible = get_talking() or _permatalk
func get_perm_talk():
	return _permatalk

#syntatic sugar for the variable that actualy determines when we are talking
var talking setget set_talking,get_talking
func set_talking(val):
	talking = val or _permatalk
	#TODO: we might benifit from actually loading a speech bubble
	#here instead of simply toggling visibility
	$SpeechBubble.visible = talking 
func get_talking():
	return $SpeechBubble.visible

#determines the type of input that the game is looking for
#options are dev (uses keys 1-7) and midi (uses midi note frequency)
#TODO: this needs a setter and a getter that changes other aspects of the game
#additionaly need to add the fourier transform or "tuner" input method
var input_mode = "dev"

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


#this function checks wether or not the given delta beat falls close enough to
#an actual rythomic beat to be valid
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

func check_action(act):
	match input_mode:
		"dev":
			return Input.is_action_just_pressed(act)
		"midi":
			#if I recall correctly this is required
			#for the NotePlayer emitting custom signals
			#TODO: more research into what past Mequam did :/
			return Globals.action_just_pressed(act)
		_:
			return false
#checks the inputs for the movement of the object
#NOTE: input_number can also be thought of as scale degree
func move_2d(delta,input_number,flavor):
	var to_move = Vector2(0,0)
	match input_number:
		4:
			to_move.x += 1
		1:
			to_move.x -= 1
		2:
			to_move.y += 1
		3:
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
	return null

#this fuction takes a scale degree, and performs the corisponding option
func respond_to_scale_degree(delta,scale_degree):
	#we do not move while we are talking
	#the speech buble is visible when we are taking
	if get_talking():
		var rythom = checkInputRythom()
		if not (rythom == 2 or rythom == 1):
			rythom = 1
		$SpeechBubble.dispNote(scale_degree,rythom,$NotePlayer.mode)
		#we keep talking if we do not play zero or perma talk is enabled
		set_talking((scale_degree != 0) or _permatalk)
	#move while not talking
	else:
		#check the input for flavor
		var tmpFlavor = run_flavor_input(delta,scale_degree)
		#move if we do not have flavor
		if (tmpFlavor == -2):
			move_2d(delta,scale_degree,flavor)
			set_flavor(-1)
		else:
			#set flavor without moving if we do have flavor
			set_flavor(tmpFlavor)
	#actualy display the input that the user gave as sound
	play_note_inp(scale_degree)
	#check to see if the player is performing a combo
	#get_node("ComboTracker").check_inputs(delta)

#this function checks which input the user pressed and passes that information to the players other movement functions
func find_input(delta):
	var i = getActionId()
	
	if i != null:
		respond_to_scale_degree(delta,i)

#this function plays the scale degree corisponding to the player input
func play_note_inp(input_number):
	#subtract 7 to move the player down an octive
	$NotePlayer.play_note(input_number-7)

#this function checks the given inputs to move the player and sets the flavor accordingly
func run_flavor_input(delta,input_number):
	#make sure that the player is moving in time
	updateRythomMomentom()
	
	var flavor = -1
	match input_number:
		6:
			flavor = 6
		5:
			#TODO: why is this setting the flavor to 7?
			flavor = 7
		_:
			#indicates that we did nothing and want to move the character
			flavor = -2
	$avatar.flavor_changed(flavor)
	return flavor

	
#runs when the player completes a combo
#TODO: give more support to this feature
func on_combo(combo_name) -> void:
	pass

#overload the default behavior on death
func die() -> void:
	hide()

#used to make the player invencible
var invencible = false

#this is called by entities when they hit US
func on_col(thing,dmg : int=1) -> void:
	if (i_timer <= 0 and !invencible):
		#these only run if we are not invencible
		if (thing.is_in_group("enemies")):
			.on_col(thing,dmg)

#this can be thought of as the actual ready function, we do this
#so we can over-ride the function isntead of stacking behavior
func main_ready():
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
#process function that is designed to be overloadable by inheriting children
func main_process(delta):
	#check the user inputs and act accordingly
	find_input(delta)
	#make sure the note player does not play forever
	limitNotePlayerTime(delta)
	
#for whatever reason _process does not get over-wridden in gdscript
#so we create a main_process to do that for us
func _process(delta):
	main_process(delta)
