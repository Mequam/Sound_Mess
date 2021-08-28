extends "res://scripts/abstracts/generic_boss.gd"

class_name CentipideBoss

#this is the projectile that we shoot that stuns the player
var medusaProjectile : PackedScene = preload("res://scenes/instance/projectiles/MedusaProjectile.tscn")
#how fast the projectile moves on launch
var initalMedusaProjectileSpeed : float = 400

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
	counter = 0
	sub_mode = val
func get_sub_mode()->String:
	return sub_mode
#used for arbitrary counting between modes and sub modes
var counter : int = 0

#adds a projcetile to the parent to launch in the given direction
func launch_projectile(dir : Vector2)->void:
	var inst : Projectile = medusaProjectile.instance()
	#set up the projectile with an initial direction and speed
	inst.dir = dir*initalMedusaProjectileSpeed+velocity
	get_parent().add_child(inst)
	inst.global_position = $Sprite/assets/head_front.global_position
	
func set_statue_frozen(val : bool)->void:
	if not statue_frozen and val:
		#stop the animation on the head
		$Sprite/AnimationPlayerHead.stop()
		#turn off the centipide chain update
		$Sprite/Tail.do_chain_update = false
		#update the animation state of each of the links
		$Sprite/Tail.link_anim_state = "Frozen"
		$Sprite/assets/body/LegsSprite/AnimationPlayer.stop()
	elif statue_frozen and not val:
		$Sprite/Tail.do_chain_update = true
		$Sprite/Tail.link_anim_state = "Run"
		$Sprite/assets/body/LegsSprite/AnimationPlayer.play($Sprite/assets/body/LegsSprite/AnimationPlayer.current_animation)
		#the parent call should take care of animating the head in the set state
		#functions of this class
	.set_statue_frozen(val)
#takes a mode and a velocity and updates the sprite
func update_sprite(mode : String,vel : Vector2):
	if abs(vel.x) > abs(vel.y):
		$YSort/Sprite/AnimationPlayer.play("IdleSide")
	else:
		$YSort/Sprite/AnimationPlayer.play("Idle")
#this script represents the behavior for the centipide statue boss
func main_ready():
	add_to_group("CentipideBoss")
	.main_ready()
	$Sprite/AnimationPlayerHead.connect("animation_finished",self,"anim_head_finished")
	set_mode("Idle")

func set_mode(val : String)->void:
	.set_mode(val)
func run(player_pos : Vector2,beat):
	match mode:
		"Idle":
			#randomly assign accelleration
			_angular_accel = randf()*PI-PI/2
			if sub_mode != "Weve" and randf() < 0.1:
				set_sub_mode("Weve")
			if player_pos.distance_squared_to(position) > 250000:
				
				velocity = (player_pos-position).normalized()*movement_speed
				#update our animation
				play_anim()
	match sub_mode:
		"Weve":
			counter += 1
			if counter >= 10:
				launch_projectile(
							((Globals.get_scene_root().get_node("player").global_position 
							- $Sprite/assets/head_front.global_position) as Vector2).normalized()
				)
				set_sub_mode("")
				play_anim()

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
	if mode == "Follow":
		modeStr = "Idle"
	
	var cardStr : String = get_cardinal_str(get_cardinal(velocity))
	$Sprite/AnimationPlayer.play(modeStr + cardStr)
	
	if sub_mode != "":
		$Sprite/AnimationPlayerHead.play(sub_mode + cardStr)
	else:	
		$Sprite/AnimationPlayerHead.play(modeStr + cardStr)
	
	var cardinal : int = get_cardinal(velocity)
	if cardinal == CARDINAL.RIGHT or cardinal == CARDINAL.LEFT:
		$Sprite/assets/body/LegsSprite/AnimationPlayer.play("Side_Run")
	else:
		$Sprite/assets/body/LegsSprite/AnimationPlayer.play("Run")

	#orientate the sprite properly
	if get_cardinal(velocity) == CARDINAL.RIGHT:
		$Sprite/assets.scale.x = -1*abs($Sprite/assets.scale.x)
	else:
		$Sprite/assets.scale.x = abs($Sprite/assets.scale.x)

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

#this function runs every frame and performs our processing
func main_process(delta):
	#buffer velocity for our animation updates
	var old_vel : Vector2 = velocity
	
	match mode:
		"Follow":
			#move directly twoards the player
			velocity = (Globals.get_scene_root().get_node("player").position-position).normalized()*4
		"Idle":
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
