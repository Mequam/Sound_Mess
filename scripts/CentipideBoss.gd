extends "res://scripts/abstracts/generic_boss.gd"

class_name CentipideBoss


#we hit the playr and the terrain
func gen_col_mask():
	return col_math.Layer.PLAYER | col_math.Layer.TERRAIN


#this is the projectile that we shoot that stuns the player
var medusaProjectile : PackedScene = preload("res://scenes/instance/projectiles/MedusaProjectile.tscn")
#how fast the projectile moves on launch
var initalMedusaProjectileSpeed : float = 400

#this is the statue that we place as an obsticle to the player
var centipideStatueSegment : PackedScene = preload("res://scenes/instance/centipideStatueSegment.tscn")

#how fast we move
var movement_speed : float = 400
#the direction we move in
var velocity : Vector2 = Vector2(0,0) setget set_velocity,get_velocity
func set_velocity(val : Vector2):
	velocity = val.normalized()
func get_velocity()->Vector2:
	return velocity
#sub mode used within other modes for animation control and the like
var sub_mode : String = "" setget set_sub_mode,get_sub_mode
func set_sub_mode(val : String)->void:
	#clear out the counter for use with other sub modes
	match val:
		"RepeatWeve":
			play_anim()
		"Weve":
			play_anim()
	counter = 0
	sub_mode = val
func get_sub_mode()->String:
	return sub_mode
#used for arbitrary counting between modes and sub modes
var counter : int = 0

#we need to overide move and collide here because of the wierd way this node moves around
#in order to get nice automatic y sorting the parent has to be a y sort node
#but in order to get move_and_collide the parent has to be a kinematic body
#so we make the parent a y sort nodee and then move it around with a child kinematic
func move_and_collide(rel_vec : Vector2, infinite_inertia: bool = true, exclude_raycast_shapes: bool = true, test_only: bool = false):
	#perform our movement
	var col = .move_and_collide(rel_vec,infinite_inertia,exclude_raycast_shapes,test_only)
	#move the parent to us
	get_parent().position += position
	position = Vector2(0,0)
	#return the collision object
	return col
#adds a projcetile to the parent to launch in the given direction
func launch_projectile(dir : Vector2)->void:
	var inst : Projectile = medusaProjectile.instance()
	#set up the projectile with an initial direction and speed
	inst.dir = dir*initalMedusaProjectileSpeed+velocity
	get_parent().get_parent().add_child(inst)
	inst.global_position = get_parent().get_node("Sprite/assets/head_front").global_position
	
func set_statue_frozen(val : bool)->void:
	if not statue_frozen and val:
		#stop the animation on the head
		get_parent().get_node("Sprite/AnimationPlayerHead").stop()
		#turn off the centipide chain update
		get_parent().get_node("Sprite/Tail").do_chain_update = false
		#update the animation state of each of the links
		get_parent().get_node("Sprite/Tail").link_anim_state = "Frozen"
		get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").stop()
	elif statue_frozen and not val:
		get_parent().get_node("Sprite/Tail").do_chain_update = true
		get_parent().get_node("Sprite/Tail").link_anim_state = "Run"
		get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").play(get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").current_animation)
		#the parent call should take care of animating the head in the set state
		#functions of this class
	.set_statue_frozen(val)
#takes a mode and a velocity and updates the sprite
func update_sprite(mode : String,vel : Vector2):
	if abs(vel.x) > abs(vel.y):
		get_parent().get_node("YSort/Sprite/AnimationPlayer").play("IdleSide")
	else:
		get_parent().get_node("YSort/Sprite/AnimationPlayer").play("Idle")
func set_mode(val : String)->void:
	match val:
		"Follow":
			movement_speed = 50
		"Idle":
			movement_speed = 300
		"IdleAttack":
			movement_speed = 400
	.set_mode(val)

#gets a cardinal direction from a vector
enum CARDINAL {UP,DOWN,LEFT,RIGHT}
func get_cardinal(dir : Vector2)->int:
	dir*=-1
	if abs(dir.x) >= abs(dir.y):
		if dir.x > 0:
			return CARDINAL.RIGHT
		return CARDINAL.LEFT
	if dir.y > 0:
		return CARDINAL.DOWN
	return CARDINAL.UP
#returns a string reminicent of a cardinal direction
#for use with animation names
func get_cardinal_str(card : int)->String:
	match card:
		CARDINAL.RIGHT:
			return "Side"
		CARDINAL.UP:
			return ""
		CARDINAL.DOWN:
			return "Back"
	return "Side"
#plays a given animation
func play_anim(player_pos : Vector2 = Vector2(0,0))->void:
	#this remaps modes to other modes so we can re-use
	#animations set up for other modes, namely idle
	var modeStr : String = mode
	var subModeStr : String = sub_mode

	#map different modes into the same behaviors for the following code	
	if mode == "Follow":
		modeStr = "Idle"
	if subModeStr == "RepeatWeve":
		subModeStr = "Weve"
	
	var cardStr : String = get_cardinal_str(get_cardinal(velocity))
	get_parent().get_node("Sprite/AnimationPlayer").play(modeStr + cardStr)
	
	#use the weve sub mode string here
	if subModeStr == "Weve":
		get_parent().get_node("Sprite/AnimationPlayerHead").play(subModeStr + cardStr)
	else:
		get_parent().get_node("Sprite/AnimationPlayerHead").play(modeStr + cardStr)
	
	var cardinal : int = get_cardinal(velocity)
	if cardinal == CARDINAL.RIGHT or cardinal == CARDINAL.LEFT:
		get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").play("Side_Run")
	else:
		get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").play("Run")

	#orientate the sprite properly
	if get_cardinal(velocity) == CARDINAL.RIGHT:
		get_parent().get_node("Sprite/assets").scale.x = -1*abs(get_parent().get_node("Sprite/assets").scale.x)
	else:
		get_parent().get_node("Sprite/assets").scale.x = abs(get_parent().get_node("Sprite/assets").scale.x)

#the rate of change of our velocity angle
#used to meander around
var _angular_accel : float = 0
#the current rate of change of our velocity angle used to save state
#as apposed to time and squared velocity so we can rely on the delta in the 
#process function
var _angular_vel : float = 0 
const MAX_ANGULAR_VELOCITY_MAGNITUDE = PI/2

func anim_finished(anim):
	pass
#called when the animation player for the head finishes
func anim_head_finished(anim):
	pass

#called when the player collides with the tail segments
#this is custom collision using the squared distance from the segment 
#and function telephone called up the chain
func player_entered_tail(player : Player,segment)->void:
	if player.collision_layer & collision_mask != 0:
		player.take_damage(1)
func get_last_tail_link()->CentiBody:
	return (get_parent().get_node("Sprite/Tail") as CentiMotor).get_last_link() as CentiBody


#this function spawns a statue segment at the given chordinents
#in the parent of our instance
func spawn_statue_segment(pos : Vector2):
	var inst = centipideStatueSegment.instance()
	
	get_parent().get_parent().add_child(inst)
	
	inst.global_position = pos
	
	return inst

#spawns a statue copy of the given tail segment at thee location of the given tail
#segment the idea here is that the copy serves as another obsticle for the playr to dodge
func spawn_statue_segment_at_link(node : CentiBody)->void:
	#create a statue at the specified position
	var inst = spawn_statue_segment(node.global_position)
	
	#syntactic sugar to help make reading things easier
	var node_animation_player  : AnimationPlayer = node.get_node("Sprite/AnimationPlayer") as AnimationPlayer
	var centipideStatueAnimationPlayer : AnimationPlayer = (inst.get_node("Sprite/AnimationPlayer") as AnimationPlayer)
	
	#sync up the animation between the two nodes
	centipideStatueAnimationPlayer.play(node_animation_player.current_animation)
	centipideStatueAnimationPlayer.seek(node_animation_player.current_animation_position,true)
	
	#this would be better if the legStab animation also contained the key frames for the legStabSide animation
	inst.get_node("Sprite/statueLegs").play("StatueSplode")
	#stop playing so we dont continue moveing
	centipideStatueAnimationPlayer.stop()
#spawns a statue copy of the last node in our tail
func spawn_statue_segment_at_last_link()->void:
	spawn_statue_segment_at_link(get_last_tail_link())
#make a copy of the whole tail!
func spawn_statue_tail()->void:
	for link in get_tail_link_list():
		spawn_statue_segment_at_link(link)

#gets an array containing a reference to each link in the tail
func get_tail_link_list()->Array:
	return get_parent().get_node("Sprite/Tail").get_link_list()

#these are the main functions of the boss that use the above functions
#to control behavior


#this script represents the behavior for the centipide statue boss
func main_ready():
	add_to_group("CentipideBoss")
	.main_ready()
	get_parent().get_node("Sprite/AnimationPlayerHead").connect("animation_finished",self,"anim_head_finished")
	set_mode("Idle")
	set_sub_mode("StatueSpawn")

func run(player_pos : Vector2,beat):
	player_pos -= get_parent().position
	#run the mode state machine	
	if mode == "Idle":
			#randomly assign accelleration
			_angular_accel = randf()*PI-PI/2
			
			#don't get to far from the player
			if player_pos.distance_squared_to(position) > 250000:
				velocity = (player_pos-position).normalized()*movement_speed
				#update our animation
				play_anim()

	#run the sub mode state machine
	if sub_mode == "Weve" or sub_mode == "RepeatWeve":
		counter += 1
		if counter >= 10:
			launch_projectile(
						((Globals.get_scene_root().get_node("player").global_position 
						- get_parent().get_node("Sprite/assets/head_front").global_position) as Vector2).normalized()
			)
			if sub_mode == "RepeatWeve":
				#this mode bounces back to repeat weve with a certain probability
				set_sub_mode("RepeatWeveWait")
			else:
				set_sub_mode("")
			play_anim()
	elif sub_mode == "RepeatWeveWait":
		if randf() < 0.075:
			#bounce back to repeat weve
			set_sub_mode("RepeatWeve")
	elif sub_mode == "StatueSpawn":
		if counter == 19: #4 beats with a zero based index gives us 3 as the emphasis beat and we do every 5 group of 4 so 5*4-1
			spawn_statue_tail()
			counter = 0
		counter += 1

#this function runs every frame and performs our processing
func main_process(delta):
	#buffer velocity for our animation updates
	var old_vel : Vector2 = velocity
	
	if mode == "Follow":
			#move directly twoards the player
			velocity = (Globals.get_scene_root().get_node("player").position-get_parent().position).normalized()*4
	elif mode == "Idle":
			#get the angular velocity
			_angular_vel += _angular_accel*delta
			#cap our velocity
			if abs(_angular_vel) > MAX_ANGULAR_VELOCITY_MAGNITUDE:
				_angular_vel = MAX_ANGULAR_VELOCITY_MAGNITUDE*sign(_angular_vel)
			#get the angular position
			var new_angle : float = velocity.angle()+_angular_vel*delta
			
			velocity = Vector2(cos(new_angle),sin(new_angle))

			
				
	
	
	#update our animation if necessary
	if get_cardinal(old_vel) != get_cardinal(velocity):
			play_anim()
	
	#move
	dmg_mv(velocity*movement_speed*delta,1)
	
	.main_process(delta)
