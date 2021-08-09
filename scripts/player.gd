extends "res://scripts/abstracts/entity.gd"

#this is the main player script
#it controls basic movement,input, animation, damage and avatar switching
#the avatars control ability usage and key modulation 

#library containing code to work with the avatar enumerators
var ava_math = preload("res://scripts/ava_code_math.gd")

#emitted when we fall into or out of time
signal rythom_score_changed
#timer used to turn off the notes that are playing
var timeout = 0
#the time offset of the smallest possible sub beat, calculated from a bellow function
var sub_beat
#the time of the players last input, stored to calculate rythom
var last_input = 0
#stores the last beat that the player played
var last_beat = 0

#used to comunicate to the avatar what type of movement we are performing
var flavor = -1 setget set_flavor,get_flavor
func set_flavor(new_flavor):
	flavor = new_flavor
	$avatar.flavor_changed(flavor)
func get_flavor():
	return flavor


#TODO: it would be MUCH better if this could be implimented in the entity class verses
#the player and generic enemy classes

#you can be permatalked and not statue frozen, so we use two variables for the bool state
var statue_frozen : bool = false setget set_statue_frozen, get_statue_frozen
func set_statue_frozen(val : bool)-> void:
	if val and not statue_frozen:
		statue_frozen = val
		#make it so we don't stop talking
		_permatalk = true
		set_talking(true)
		$avatar.stop_animation()
		modulate = Color.darkgray
		var outStatue = load("res://scenes/instance/statue_frozen_switch.tscn").instance()
		get_parent().add_child(outStatue)
		#tell the node to listen to us
		#outStatue.get_node("singingSwitch").get_node("DialogChoiceList").enabled = true
		outStatue.get_node("singingSwitch").get_node("DialogChoiceList").connect("completed_dialog",self,"unstatue_freeze")
		outStatue.get_node("singingSwitch").get_node("DialogChoiceList").connect("completed_dialog_no_arg",outStatue,"queue_free")
		outStatue.global_position = global_position
		
		#spawn the singing statue and connect it properly
	if not val and statue_frozen:
		modulate = Color.white
		_permatalk = false
		set_talking(false)
		$avatar.play_animation($avatar/Sprite/AnimationPlayer.current_animation)
		statue_frozen = val
func get_statue_frozen()->bool:
	return statue_frozen
#inteanded to be called from a signal to unfreeze us
func unstatue_freeze(dialog)->void:
	set_statue_frozen(false)
	
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
#used to score how well we are keeping track of rythom
var rythom_score = 0 setget set_rythom_score,get_rythom_score
func set_rythom_score(val):
	if val != rythom_score:
		emit_signal("rythom_score_changed",rythom_score)
	rythom_score = val
func get_rythom_score():
	return rythom_score
	
#collision layer and mask generators
func gen_col_layer()->int:
	return (.gen_col_layer() | 
			col_math.Layer.PLAYER | 
			col_math.ConstLayer.PLAYER)
func gen_col_mask()->int:
	return (.gen_col_mask() | 
			col_math.Layer.ENEMY | 
			col_math.Layer.TERRAIN | 
			col_math.Layer.PICKUPS) 

#this function retrives a given speed based on our rythom score
func RythomToSpeed():
	if (rythom_score < 1):
		return 5
	elif (rythom_score < 2):
		return  30
	elif (rythom_score < 3):
		return 90
	else:
		return 90

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
		if (target-beat_err <= delta and delta <= target+beat_err):
			return i
	return -100

#this fuction updates our momentom to match our rythom
func updateRythomMomentom():
	var beat_value = checkInputRythom()
	if (beat_value != -100):
		last_beat = beat_value
		set_rythom_score(rythom_score+1)
	else:
		set_rythom_score(rythom_score-2)
	if (rythom_score < -2):
		set_rythom_score(-2)
	if (rythom_score > 4):
		set_rythom_score(4)

#loads an avatar given that avatars enumerator
func load_avatar_enum(avatar_enum : int) -> void:
	load_avatar_path(ava_math.avatar_enum2path(avatar_enum))

#this function changes the player avatar to the given avatar
func load_avatar_path(path : String)->void:
	load_avatar(load(path).instance())
	
#serves as a buffer zone while we wait for the previous avatar to clear out
var buffer_avatar : Node2D
#loads an avatar give a node
func load_avatar(avatar : Node2D)->void:
	$avatar.queue_free()
	buffer_avatar = avatar
#this function moves us in the given direction for player control
func move_dir(dir,delta):
	#TAG:
	#	this is where we get the players speed
	#	multiply this to increase base movement speed
	var working_speed = 2*RythomToSpeed()
	#the avatar animates the direction that we move in
	var collided = move_and_collide(delta*dir*working_speed)
	$avatar.dir_anim(dir)
	if (collided):
		#decide what to do with the thing that we hit
		collision_action(collided)

#syntactic sugar that sets the mode of the note player
func set_musical_input_mode(mode : int)->void:
	$NotePlayer.mode = mode

#checks the inputs for the movement of the object
#NOTE: input_number can also be thought of as scale degree
func move_2d(input_number,flavor):
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
	var mult = 1
	if (rythom_score >= 1):
		#let the avatar decide what our flavors do
		mult = $avatar.run_flavor(flavor,to_move,1)
		#mult=$avatar.run_flavor(flavor,to_move,delta)
	move_dir(to_move*mult,1)
	$avatar.clean_flavor(flavor,to_move,1)

#decide what to do with the thing we hit
func collision_action(collision):
	if (collision.collider.is_in_group("enemies") and collision.collider.has_method("on_col")):
		collision.collider.on_col(self,1)

#this fuction takes a scale degree, and performs the corisponding option
func respond_to_scale_degree(scale_degree):
	#we have a valid scale degree
	#or not a wrong note
	#the movement inputs loop at twice the speed of the musical inputs	
	if scale_degree != null:
		#movement and specials use the mapped degree
		var mapped_degree = $NotePlayer.scale_math.deg2actionDeg(scale_degree)

		#we do not move while we are talking
		#the speech buble is visible when we are taking
		if get_talking():
			var rythom = checkInputRythom()
			if not (rythom == 2 or rythom == 1):
				rythom = 1
			$SpeechBubble.dispNote(scale_degree,rythom,$NotePlayer.mode)
			#we keep talking if we do not play zero (low note so -7) or perma talk is enabled
			set_talking((scale_degree != -7) or _permatalk)
		#move while not talking
		else:
			#check the input for flavor
			var tmpFlavor = run_flavor_input(mapped_degree)
			#move if we do not have flavor
			if (tmpFlavor == -2):
				move_2d(mapped_degree,flavor)
				set_flavor(-1)
			else:
				#set flavor without moving if we do have flavor
				set_flavor(tmpFlavor)
		#actualy display the input that the user gave as sound
		play_note_inp(scale_degree)
		
		#let the rest of the game know that the player detected a valid action
		#and pass them the action
		call_game_player_watch(scale_degree)
		
		#check to see if the player is performing a combo
		#get_node("ComboTracker").check_inputs(delta)

#alerts nodes subscribed to watch the players inputs that the player has detected a valid
#scale degree 
func call_game_player_watch(scale_degree : int,pressed : bool = true):
	var to_call : String = "_player_action_pressed"
	if not pressed:
		to_call = "_player_action_released"
	get_tree().call_deferred("call_group","player_note_action_listener",to_call,scale_degree)

#this function plays the scale degree corisponding to the player input
func play_note_inp(input_number):
	#subtract 7 to move the player down an octive
	$NotePlayer.play_note(input_number)

#this function checks the given inputs to move the player and sets the flavor accordingly
func run_flavor_input(input_number):
	#make sure that the player is moving in time
	updateRythomMomentom()
	
	var flavor = -1
	match input_number:
		6:
			flavor = 6
		5:
			#this sets flavor to 7 because we are in the lower octive
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

#this is called by entities when they hit US
func on_col(thing,dmg : int=1) -> void:
	#these only run if we are not invencible
	if (thing.is_in_group("enemies")):
		.on_col(thing,dmg)

#this can be thought of as the actual ready function, we do this
#so we can over-ride the function isntead of stacking behavior
func main_ready():
	print("running ready")
	$health_bar.sync_disp()
	#let the avatar load
	$avatar.load_avatar()
	
	#connect all of our child nodes
	#get_node("ComboTracker").connect("combo_found",self,"on_combo")
	
	call_deferred("add_to_group","player")
	call_deferred("add_to_group","midi_input")
	.main_ready()
	print("survived main_ready")


#this functio is called to make sure that the note player is playing or ONE blip
func limitNotePlayerTime(delta):
		#this code snippet ensures that we play short blips
	if (get_node("NotePlayer").playing):
		timeout += delta
		if (timeout >= .1):
			timeout = 0
			get_node("NotePlayer").stop()
#process function that is designed to be overloadable by inheriting children
func main_process(delta):
	#check the user inputs and act accordingly
	#find_input(delta)
	#make sure the note player does not play forever
	limitNotePlayerTime(delta)
#for whatever reason _process does not get over-wridden in gdscript
#so we create a main_process to do that for us
func _process(delta):
	main_process(delta)

#called when the avatar leaves the tree
func _on_avatar_tree_exited():
	add_child(buffer_avatar)
	$avatar.load_avatar()

#determines the type of input that the game is looking for
#options are dev (uses keys 1-7) and midi (uses midi note frequency)
#TODO: this needs a setter and a getter that changes other aspects of the game
#additionaly need to add the fourier transform or "tuner" input method
enum INPUT_MODES {ANY,DEV,MIDI}
var input_mode : int = INPUT_MODES.ANY
#this code is responcible for running all input events in the game
#all of the game runs on one of either two forms of input

#scale degrees: ranging from -7<->6 : control sound and certain combos, derived from modular note pitches
#action degrees: ranging from 0<->6 : control player actions like movement and specials, derived from scale degrees

#action degrees  
#	used to determine things like player movment and actions
#	are computed by the object that recives scale_degrees using the scale math deg2actionDeg function
#	^ in otherwords this input code outputs scale degrees
#scale degrees 
#	are used to play the proper note in responce to midi inputs
#	and for some special cases where we want to use the range 0<->7 instead of 0<->6
#	basically anywhere we need player input wthout strict scale degrees
func handle_input(event : InputEvent):
	if input_mode == INPUT_MODES.DEV or input_mode == INPUT_MODES.ANY:
		for i in range(0,8):
			if event.is_action("NOTE_"+str(i)):
				if event.is_pressed():
						#The games developer inputs range from 0-7
						
						#these need to be mapped to -7-0 to be interpreted properly
						#by the rest of the game
						
						#basically we convert the action degrees to scale degrees before outputing them to 
						#the rest of the game so they look like they came from the midi inputs
					respond_to_scale_degree(i-7)
				else:
						#tell the game we released that input
					call_game_player_watch(i-7,false)
func _unhandled_input(event : InputEvent):	
	#use the overrideable function
	handle_input(event)
func _midi_note_down(pitch):
	if input_mode == INPUT_MODES.MIDI or input_mode == INPUT_MODES.ANY:
		#respond to the pitch properly
		call_deferred("respond_to_scale_degree",$NotePlayer.scale_math.pitch2deg(pitch))
func _midi_note_up(pitch):
	if input_mode == INPUT_MODES.MIDI or input_mode == INPUT_MODES.ANY:
		var note = $NotePlayer.scale_math.pitch2deg(pitch)
		if note != null:
			#alert the rest of the game that our pitch changed
			call_game_player_watch($NotePlayer.scale_math.pitch2deg(pitch),false)
