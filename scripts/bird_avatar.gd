extends "res://scripts/abstracts/avatar.gd"

var pushProjectile = preload("res://scenes/instance/projectiles/birdPushProjectile.tscn")

#how many moves we can make while flying
var max_flight_distance : int = 4
#how far we can fly
var flight_distance : int = 0
var flying : bool setget set_flying,get_flying
var initial_pos : Vector2 = Vector2(0,0)
func push(dir : Vector2):
	var inst = pushProjectile.instance()
	inst.dir = dir
	inst.position = get_parent().position
	get_parent().get_parent().add_child(inst)
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
		print("[bird avatar] prev layer " + str(parent.collision_layer))
		#set the collision to the default collision layer, shifted into the flight zone
		parent.collision_layer = parent.col_math.shift_collision(parent.gen_col_layer(),parent.col_math.SuperLayer.FLIGHT)
		parent.collision_mask = parent.col_math.shift_collision(parent.gen_col_mask(),parent.col_math.SuperLayer.FLIGHT)
		print("[bird avatar] new layer " + str(parent.col_math.shift_collision(parent.gen_col_layer(),parent.col_math.SuperLayer.FLIGHT)))
	#we should not be flying
	elif not val:
		#reset the collision to be on the normal layer
		var parent = get_parent()
		$Sprite.position = initial_pos
		$Shadow.visible = false
		parent.collision_layer = parent.gen_col_layer()
func get_flying()->bool:
	var parent = get_parent()
	return parent.col_math.in_layer_no_constants(
		parent.collision_layer,
		parent.col_math.shift_collision(parent.gen_col_layer(),parent.col_math.SuperLayer.FLIGHT))

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
func run_six(to_move,delta)->float:
	set_flying(not get_flying())
	#we push in the opposite direction of player movement
	if get_flying():
		push(-to_move)
	return 2.0
func run_flavorless(to_move,delta)->float:
	if get_flying():
		if not get_in_time():
			set_flying(false)
			get_parent().take_damage(1)
		flight_distance += 1
		if flight_distance >= max_flight_distance:
			set_flying(false)
		return 1.5
	return 1.0
func parent_rythom_changed(score : int):
	if get_flying() and not get_in_time():
		set_flying(false)
		#flight is risky
		get_parent().take_damage(1)
func init():
	get_parent().connect("rythom_score_changed",self,"parent_rythom_changed")
	.init()
	#2 = mixolidian birds :D
	set_mode(2)
func _ready():
	init()
