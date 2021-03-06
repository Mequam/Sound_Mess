extends "res://scripts/abstracts/avatar.gd"

var pushProjectile = preload("res://scenes/instance/projectiles/birdPushProjectile.tscn")
#how many moves we can make while flying
var max_flight_distance : int = 4
#how far we can fly
var flight_distance : int = 0
var initial_pos : Vector2 = Vector2(0,0)

#the feather that we shoot
var feather = preload("res://scenes/instance/projectiles/Feather.tscn")

#private flag that toggles between the default animation behavior and falling behavior
var _falling : bool = false
func push(dir : Vector2):
	var inst = pushProjectile.instance()
	inst.dir = dir
	inst.position = get_parent().position
	get_parent().get_parent().add_child(inst)
var flying : bool setget set_flying,get_flying
func set_flying(val : bool)->void:
	var fly = get_flying()
	#we should be flying and are not currently
	if val and not fly:
		#reset the flight distance
		flight_distance = 0
		#the sprite is high when we fly
		$Sprite.position = initial_pos + Vector2(0,-400)
		$Shadow.visible = true
		
		var parent = get_parent()
		#set the collision to the default collision layer, shifted into the flight zone
		parent.collision_layer = parent.col_math.shift_collision(parent.gen_col_layer(),parent.col_math.SuperLayer.FLIGHT)
		parent.collision_mask = parent.col_math.shift_collision(parent.gen_col_mask(),parent.col_math.SuperLayer.FLIGHT)
	#we should not be flying
	elif not val:
		#reset the collision to be on the normal layer
		var parent = get_parent()
		$Sprite.position = initial_pos
		$Shadow.visible = false
		parent.collision_layer = parent.gen_col_layer()
		parent.collision_mask = parent.gen_col_mask()
func get_flying()->bool:
	var parent = get_parent()
	return parent.col_math.in_layer_no_constants(
		parent.collision_layer,
		parent.col_math.shift_collision(parent.gen_col_layer(),parent.col_math.SuperLayer.FLIGHT))
#shoots a feather in the given direction at the given speed
func shoot_feather(dir : Vector2)->void:
	var instance = feather.instance()
	#give the feather the information it needs to run
	#BEFORE spawning it into the scene
	instance.dir = dir
	instance.position = get_parent().position
	instance.flying = get_flying()
	
	#actualy add the feather to the scene
	get_parent().get_parent().add_child(instance)
func play_idle(last_anim : String = "Move_Front") -> void:
	if not get_flying():
		#we are not flying
		.play_idle(last_anim)
	else:
		#we are, use the flight animations
		match last_anim:
			"Move_Front":
				$Sprite/AnimationPlayer.play("Fly")
			"Move_Left":
				$Sprite/AnimationPlayer.play("FlyLeft")
			"Move_Back":
				$Sprite/AnimationPlayer.play("FlyBack")
func run_seven(to_move,delta)->float:
	if (to_move != Vector2(0.0,0.0)):
		shoot_feather(to_move)
	return -0.5
func run_six(to_move,delta)->float:
	#if we are flying, we toggle flying, if we get a directional
	#we toggle flying
	if to_move != Vector2(0.0,0.0):
		set_flying(not get_flying())
		#we push in the opposite direction of player movement
		if get_flying():
			push(-to_move)
		return 2.0
	#the player is not flying and pressed the root/ non motion note
	elif not get_flying():
		var parent = get_parent()
		$Sprite/AnimationPlayer.play("ThrowFlap")
		for node in get_tree().get_nodes_in_group("kinematicEnemies"):
			if parent.col_math.in_layer(node.collision_layer,parent.gen_col_mask()) and parent.position.distance_squared_to(node.position) <= 40000:
				node.flight_thrown = true
	return 1.0

#returns true when we fall
#note this function assumes that we are flying
func checkFall() -> bool:
	var ret_val = not get_in_time()
	if ret_val:
		set_flying(false)
		#mark us as falling for the animation player
		#this is to overide the animations that are normaly played on
		#the direcitonal
		_falling = true
		$Sprite/AnimationPlayer.play("Fall")
		get_parent().take_damage(1)
	return ret_val

#update our flight counter
func updateFlight(to_move : Vector2 ,dist : int = 1):
	if not checkFall():
		flight_distance += dist
		if flight_distance >= max_flight_distance:
			#we have flown too far
			#land
			set_flying(false)
#used to increase our speed when flying
func run_flavorless(to_move,delta)->float:
	if get_flying():
		#update flight
		updateFlight(to_move)
		#move at 1.5 speed while flying
		return 1.5
	return 1.0
#if the rythom score changed and we are flying
#run the fall check routine
func parent_rythom_changed(rythom):
	if get_flying():
		checkFall()

#no matter what, if we have finished the falling animation
#reset the animation overide so we do not play it again on accident
func anim_finished(anim : String) -> void:
	if anim == "Fall":
		_falling = false
	elif anim == "ThrowFlap":
		$Sprite/bird_up_particles.emitting = true
	.anim_finished(anim)
func dir_anim(dir : Vector2,prefix : String = "") -> void:
	#if there is an animation overide play the fall animation instead
	if _falling:
		#note that falling is set to false when this animation resolves
		$Sprite/AnimationPlayer.play("Fall")
	else:
		#normal behavior
		.dir_anim(dir,prefix)
func load_avatar():
	#TODO: get the speach bubble colors for the bird
	
	#2 = mixolidian birds :D
	set_mode(2)
	code = get_parent().ava_math.Avatars.BIRD
	
	.load_avatar()
func init():
	get_parent().connect("rythom_score_changed",self,"parent_rythom_changed")
	.init()
func _ready():
	initial_pos = $Sprite.position
	init()
