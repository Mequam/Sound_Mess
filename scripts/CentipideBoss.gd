extends "res://scripts/abstracts/generic_boss.gd"

class_name CentipideBoss

var spider_enemy : PackedScene = preload("res://scenes/instance/entities/enemies/Spider_Enemy.tscn")
var statue_enemy : PackedScene = preload("res://scenes/instance/entities/enemies/StatueEnemy.tscn")
var spawn_projectile : PackedScene = load("res://scenes/instance/projectiles/SpawnProjectile.tscn")

#we hit the playr and the terrain
func gen_col_mask():
	return col_math.Layer.PLAYER | col_math.Layer.TERRAIN

#keeps track of how many enemies that we spawned in
#we spawn in an enemy
var enemy_count : int = 0 setget set_enemy_count,get_enemy_count
func set_enemy_count(val : int):
	enemy_count = val
func get_enemy_count()->int:
	return enemy_count

#freezes us when we free a statue
func freeze(enemy,status,value):
	if status == "statue_frozen":
		set_statue_frozen(!value)
	if not value:
		enemy.queue_free()

#this is called when spawn projectiles that we launch spawn an enemy into the game
#we need to connect the enemies signals here because as far as I can tell 
#custom signals has to be in the tree to be connected
func on_projectile_enemy_spawn(enemy):
	enemy.connect("status_update",self,"freeze")

func spawn_enemy()->void:
	var spawn_projectile : SpawnProjectile = load("res://scenes/instance/projectiles/SpawnProjectile.tscn").instance()
	spawn_projectile.to_spawn = get_spawn_enemy()
	#the enemy decreases the projectile count
	spawn_projectile.to_spawn.connect("ready",self,"incriment_enemy_count")
	spawn_projectile.to_spawn.connect("die",self,"decriment_enemy_count")
	spawn_projectile.connect("on_spawn",self,"on_projectile_enemy_spawn")
	
	spawn_projectile.dir = (LoadData.get_player_pos()-get_parent().position).normalized()
	get_parent().get_parent().add_child(spawn_projectile)
	
	spawn_projectile.position = get_parent().position
	
	#reset the enemy spawn beat
	enemy_spawn_beat = 0

#returns an enemy for the spawn function
#this function ONLY returns a type of enemy, it does
#nothing to prep the enemy for spawning
func get_spawn_enemy()->Enemy:
	var inst : Enemy = spider_enemy.instance()
	match super_mode:
		SuperMode.UPONE:
			if randf() < 0.5:
				inst = statue_enemy.instance()
		SuperMode.UPTWO:
			if randf() < 0.75:
				inst = statue_enemy.instance()
		SuperMode.UPTHREE:
			inst = statue_enemy.instance()
	return inst
#these are inteanded to be called via signal from enemies we spawn in
func incriment_enemy_count()->void:
	enemy_count += 1
	if enemy_count >= 2:
		enemy_spawn_beat = -1
func decriment_enemy_count()->void:
	enemy_count -= 1
	if enemy_count == 0:
		enemy_spawn_beat = 0

#this is the projectile that we shoot that stuns the player
var medusaProjectile : PackedScene = preload("res://scenes/instance/projectiles/MedusaProjectile.tscn")
#how fast the projectile moves on launch
var initalMedusaProjectileSpeed : float = 400

#this is the statue that we place as an obsticle to the player
var centipideStatueSegment : PackedScene = preload("res://scenes/instance/centipideStatueSegment.tscn")

#how fast we move
var movement_speed : float = 50

#the direction we move in
var velocity : Vector2 = Vector2(0,0) setget set_velocity,get_velocity
func set_velocity(val : Vector2):
	velocity = val.normalized()
func get_velocity()->Vector2:
	return velocity

#used in states that require a force to be applied to a seperate velocity 
#namely the circular motion state where we apply a force from the center
#to the player
#not currently used, left as a comment in case we want to add that feature
#var center_vel : Vector2 = Vector2(0,0)

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
	
	#inner_beat = 0
	
	sub_mode = val
func get_sub_mode()->String:
	return sub_mode

enum SuperMode {INITIAL,UPONE,UPTWO,UPTHREE}
#super mode used to control the changes between mode and sub mode
var super_mode : int = 0 setget set_super_mode,get_super_mode
func set_super_mode(val : int)->void:
	super_mode = val
func get_super_mode()->int:
	return super_mode

enum TargetMode {
	PLAYER, #go to where the player is
	INITIAL_POSITION,#go to the buffered position
	RELATIVE # go to our position + buffered position, basicaly works like velocity
}
#stores the mode used by the boss to set the center of the circle
var target_mode : int = TargetMode.PLAYER


var buffered_target : Vector2 = Vector2(0,0) setget set_buffered_target, get_buffered_target
func set_buffered_target(val : Vector2):
	buffered_target = val
	target_mode = TargetMode.INITIAL_POSITION
func get_buffered_target()->Vector2:
	return buffered_target

#used for arbitrary counting between modes and sub modes
var counter : int = 0
#the angle that the circle mode uses
var angle : float = 0

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
	
var projectile_count : int = 0
func incriment_projectile_count()->void:
	projectile_count += 1
	print("UPDATING PROJECTILE COUNT: " + str(projectile_count))
func decriment_projectile_count()->void:
	projectile_count -= 1
	print("UPDATING PROJECTILE COUNT: " + str(projectile_count))
#do not spawn projectiles if we would have more than this amount
var max_projectile_count : int = 6
#adds a projcetile to the parent to launch in the given direction
func launch_projectile(dir : Vector2)->void:
	if projectile_count < max_projectile_count:
		var inst : Projectile = medusaProjectile.instance()
		#set up the projectile with an initial direction and speed
		inst.dir = dir*initalMedusaProjectileSpeed+velocity
		#increase the projectile count
		incriment_projectile_count()
		#decriment the count when the projectile despawns
		inst.connect("despawn",self,"decriment_projectile_count")
		get_parent().get_parent().add_child(inst)
		inst.global_position = get_parent().get_node("Sprite/assets/head_front").global_position
	else:
		print("Reached max projectile count")

func set_statue_frozen(val : bool)->void:
	if not statue_frozen and val:
		#stop the animation on the head
		get_parent().get_node("Sprite/AnimationPlayerHead").stop()
		get_parent().get_node("Sprite/AnimationPlayer").stop()
		#turn off the centipide chain update
		get_parent().get_node("Sprite/Tail").do_chain_update = false
		#update the animation state of each of the links
		get_parent().get_node("Sprite/Tail").link_anim_state = "Frozen"
		get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").stop()
		
		get_parent().modulate = Color.darkgray
	
	elif statue_frozen and not val:
		get_parent().get_node("Sprite/Tail").do_chain_update = true
		get_parent().get_node("Sprite/Tail").link_anim_state = "Run"
		get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").play(get_parent().get_node("Sprite/assets/body/LegsSprite/AnimationPlayer").current_animation)
		
		get_parent().modulate = Color.white
		
		$health_bar.inv = false
		$health_bar.hp -= 2
		$health_bar.inv = true
		
		if super_mode < SuperMode.UPTHREE:
			super_mode += 1
		
		#the parent call should take care of animating the head in the set state
		#functions of this class
	.set_statue_frozen(val)
func spawn_switch()->Node:
	var switch = .spawn_switch()
	
	#move the switch from our child to our parents as the overloaded function
	#spawns the switch in as a child of our parent and wee need it a parent parent child
	get_parent().remove_child(switch)
	get_parent().get_parent().add_child(switch)
	
	switch.global_position = global_position
	return switch
#takes a mode and a velocity and updates the sprite
func update_sprite(mode : String,vel : Vector2):
	if abs(vel.x) > abs(vel.y):
		get_parent().get_node("YSort/Sprite/AnimationPlayer").play("IdleSide")
	else:
		get_parent().get_node("YSort/Sprite/AnimationPlayer").play("Idle")
#use a space for our default value because we have to be able to use an empty string
func set_mode(val : String,sub_mode_val : String = " ",movement_speed_factor : float = 1)->void:
	print("\t updating mode to " + val)
	print("\t with sub mode of \""+sub_mode_val+"\"")
	print("\t movement speed factor of " + str(movement_speed_factor))
	
	#note circle mode does not set its speed in the set mode function
	#because that mode has special cases of speed when determinine radius
	match val:
		"Follow":
			movement_speed = 300
			#we allways follow where the player was, not where they are
			set_buffered_target(Globals.get_scene_root().get_node("player").position)
		"Idle":
			movement_speed = 700
	movement_speed*=movement_speed_factor
	if sub_mode_val != " ":
		set_sub_mode(sub_mode_val)
	inner_beat = 0
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
	if mode == "Follow" or mode == "Circle" or mode == "Follow":
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

#speed/radius = angular_vel
#speed =  angular_vel*radius
func get_circle_angular_vel(radius : float,speed : float)->float:
	return speed / radius
#sets the circle radius and speed
func circle(radius : float, speed : float)->void:
	movement_speed = speed
	_angular_vel = get_circle_angular_vel(radius,speed)
#changes the mode to circle and sets the circle radius and speed
func circle_mode_change(radius : float,speed : float,sub_mode : String = " ")->void:
	circle(radius,speed)
	set_mode("Circle",sub_mode)
#changes the radius of the circle in circle mode such that angular velocity is conserved
func conserve_angular_velocity_radius_cange(radius : float)->void:
	#this will conserve velocity but move us closer to the target
	_angular_vel = get_circle_angular_vel(radius,movement_speed)
#these are the main functions of the boss that use the above functions
#to control behavior

#this function updates the mode of the boss using the super mode
func update_mode()->void:
	match super_mode:
		SuperMode.INITIAL:
			print(mode)
			print("\tinner_beat " + str(inner_beat))
			match mode:
				"Idle":
					match sub_mode:
						"":
							if inner_beat >= 32:
								if randf() < 0.75:
									set_sub_mode("RepeatWeve")
									#begin the process again
									inner_beat = 0
								else:
									set_follow_mode_at_point(Globals.get_scene_root().get_node("player").position,"",1)
						#this should never happen, but just in case
						"StatueSpawn":
							set_sub_mode("")
						_:
							if inner_beat >= 32:
								set_sub_mode("")
				"Follow":
					#this also exists when we the visibility notifier indicates we left the screen
					if inner_beat >= 64:
						set_mode("Idle","",0.75)
				#this should never happen, but just in case we get to an error state
				"Circle":
					#bounce back to our IDLE mode
					set_mode("Idle","RepeatWeve",0.5)
					

		SuperMode.UPONE:
			match mode:
				"Circle":
					match inner_beat:
						64:
							conserve_angular_velocity_radius_cange(circle_mode_radius()*0.75)
						128:
							conserve_angular_velocity_radius_cange(circle_mode_radius()*0.75)
						_:
							#use the equality juuuust in case
							if inner_beat > 64:
									set_follow_mode_at_point(Globals.get_scene_root().get_node("player").position,"StatueSpawn",2.5)
				"Follow":
					if inner_beat >= 8:
						set_mode("Idle","RepeatWeve")
				"Idle":
					#if we made it to 8 beats
					if inner_beat >= 32:
						#mabye enter circle mode
						if randf() < 0.5:
							#target the player as the center
							target_mode = TargetMode.PLAYER
							circle_mode_change(500,900)
							set_sub_mode("StatueSpawn")
							statue_spawn_beats = 9
						else:
							#back to spawning scary stuff
							inner_beat = 0
		SuperMode.UPTWO:
			match mode:
				"Circle":
					if inner_beat >= 32:
						if randf() < 0.6: #we MIGHT move into the follow attack
							#target the playeres current position
							print("changing out of statue mode")
							set_follow_mode_at_point(Globals.get_scene_root().get_node("player").position,"RepeateWeve",2)
						else:
							#if we dont alternate between spawning statues and shooting stuff
							if sub_mode == "StatueSpawn":
								sub_mode = "RepeateWeve"
							else:
								sub_mode = "StatueSpawn"
							inner_beat = 0
				"Follow":
					#follow the player for longer this time
					if inner_beat >= 16:
						#we move into the idel mode while targiting the playere
						set_mode("Idle","StatueSpawn")
						target_mode = TargetMode.PLAYER
				"Idle":
					#idle for longer
					print("Idle mode " + str(inner_beat))
					if inner_beat >= 64:
						print("[Centipide] changing out of idle mode")
						if sub_mode == "StatueSpawn":
							set_sub_mode("RepeatWeve")
						else:
							#ensure that we are clear for the circle mode
							target_mode = TargetMode.PLAYER
							_angular_vel = 0
							circle_mode_change(500,1000,"StatueSpawn")
							
						inner_beat = 0
		SuperMode.UPTHREE:
			match mode:
				"Circle":
					#_angular accell determins if we shrink the circle or not, if we are shrinking we only get out after having shrunk
					if ((_angular_accel == 0 and inner_beat >= 4) or #not shrinking condition, stay for 4 beats
						(_angular_accel != 0 and circle_mode_radius() <= 10)): #shrinking condition, stay till close to player
						match sub_mode:
							"StatueSpawn":
								if randf() < 0.5:
									circle(100,movement_speed)
								else:
									set_mode("Idle")
								#either way we are going back to weveing
								set_sub_mode("RepeateWeve")
							_: #not statue spawn, so probably weve
								set_mode("Idle","StatueSpawn")
				"Idle":
					if inner_beat >= 4:
						match sub_mode:
							"StatueSpawn":
								set_mode("Follow","RepeateWeve")
							_:
								set_mode("Circle","StatueSpawn")
								_angular_accel = 100
				"Follow":
					if inner_beat >= 6: #this set of 3 will feel wierd and throw off the player cuz every thing else is in sets of 4 >:>
						set_mode("Idle")
						if randf() < 0.25:
							set_sub_mode("StatueSpawn")
						else:
							set_sub_mode("RepeateWeve")
#this script represents the behavior for the centipide statue boss
func main_ready():
	add_to_group("CentipideBoss")
	.main_ready()
	get_parent().get_node("Sprite/AnimationPlayerHead").connect("animation_finished",self,"anim_head_finished")
	set_mode("Idle")
	$health_bar.inv = true
func take_damage(dmg : int):
	.take_damage(dmg)
	#get ANGRY if we got hit
	if super_mode < SuperMode.UPTHREE:
		super_mode += 1
	else:
		super_mode = SuperMode.UPTHREE
func get_tail_rotation_speed()->float:
	return movement_speed

var statue_spawn_beats : int = 19
var enemy_spawn_beat : int = 0
func run(player_pos : Vector2,beat):
	player_pos -= get_parent().position
	if enemy_spawn_beat >= 4 and enemy_count < 4:
		spawn_enemy()
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
		#dont run anything with randum numbers counters or weird state machines 
		#if we dont want to spawn projectiles
		
		#NOTE: we COULD change modes from this, but other code relies on 
		#us bieng in weve modes, and this achives the same result
		#without interfering with that state
		if projectile_count < max_projectile_count:
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
		if counter >= statue_spawn_beats: #4 beats with a zero based index gives us 3 as the emphasis beat and we do every 5 group of 4 so 5*4-1
			spawn_statue_tail()
			counter = 0
		counter += 1
	update_mode()
	inner_beat += 1
	if enemy_spawn_beat >= 0:
		enemy_spawn_beat += 1
#gets the center of the circle used in the circle mode
func getTarget()->Vector2:
	match target_mode:
		TargetMode.PLAYER:
			return Globals.get_scene_root().get_node("player").position
		TargetMode.INITIAL_POSITION:
			return get_buffered_target()
		_:
			#just in case
			return get_buffered_target()
	#we should never get here, but just in case
	return Vector2(0,0)
#syntactic sugar function that gets the radius that the boss uses in circle mod
func circle_mode_radius()->float:
	return movement_speed/_angular_vel

func set_follow_mode_at_point(target : Vector2,sub_mode : String = " ",speed_mult : float = 1)->void:
	velocity = (target-get_parent().position).normalized()
	set_mode("Follow",sub_mode,speed_mult)
#this function runs every frame and performs our processing
func main_process(delta):
	#buffer velocity for our animation updates
	var old_vel : Vector2 = velocity
	
	#the follow mode only goes in a straight line
	#if mode == "Follow":
	#		#move directly twoards the player
	#		velocity = (getTarget()-get_parent().position).normalized()
	if mode == "Idle":
			#get the angular velocity
			_angular_vel += _angular_accel*delta
			#cap our velocity
			if abs(_angular_vel) > MAX_ANGULAR_VELOCITY_MAGNITUDE:
				_angular_vel = MAX_ANGULAR_VELOCITY_MAGNITUDE*sign(_angular_vel)
			#get the angular position
			var new_angle : float = velocity.angle()+_angular_vel*delta
			
			velocity = Vector2(cos(new_angle),sin(new_angle))
	elif mode =="Circle": #or "ForceCircle":
		#movement speed will get factored in later anyways
		#-sin is the derivative of cos and cos is the derivative of sin
		var x : float = cos(angle)
		var y : float = sin(angle)
		#when moving in a circle we move 90 to the center
		#also proves that the derivative of cosin is negative sin using linear
		#algebra which is cool
		velocity = Vector2(-y,x) 
		
		#we also move twoards the player
		# r = m/s radius is movment_speed / movement vector rotation rate
		var center : Vector2 = get_parent().position - (Vector2(x,y)*circle_mode_radius())
		
		#get the center of the circle
		var target_center : Vector2 = getTarget()
		var twoards_center = target_center-center
		if twoards_center.length_squared() > 100:
			velocity += twoards_center.normalized()
		
		angle = angle+delta*_angular_vel
		#for shrinking the circle
		circle(circle_mode_radius()-_angular_accel*delta,movement_speed)
			
	
	
	#update our animation if necessary
	if get_cardinal(old_vel) != get_cardinal(velocity):
			play_anim()
	
	#move
	dmg_mv(velocity*movement_speed*delta,1)
	
	.main_process(delta)


func _on_VisibilityNotifier2D_screen_exited():
	#exits the mode based on the super mode and the fact we are no longer visible
	match super_mode:
		SuperMode.INITIAL:
			if mode == "Follow":
				set_mode("Idle","",0.75)
