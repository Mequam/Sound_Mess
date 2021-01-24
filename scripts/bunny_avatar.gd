extends "res://scripts/abstracts/avatar.gd"
var running_7 = false
var dmg7 = 1

#this function runs when the avatar is loaded by the player
func load_avatar():
	set_speech_color(Color(0,1,0.576,0.8),Color(1,0.4,0,0.8))
	set_mode(1)
func run_seven(to_move,delta):
	running_7 = true
	dmg7 = 1 if get_last_beat() == 2 else 0 
	return 2
func run_six(to_move,delta):
	#constant that tells us how far we move
	var burrow_distance = 1.5
	
	$Sprite.burrow_dir(to_move,burrow_distance*333.33*1.5)
	var parent = get_parent()
	#you do not collide with burrow terrain
	if (parent.collision_mask & int(pow(2,5)) != 0):
		parent.collision_mask -= pow(2,5)
	#you do not collide with enemies
	if (parent.collision_mask & int(pow(2,2)) != 0):
		parent.collision_mask -= pow(2,2)
	#you are now on the burrow layer
	parent.collision_layer = 2
	
	var player_health_bar = parent.get_node("health_bar")
	
	#make the player invulnerable when they attack
	player_health_bar.do_buffer = false
	player_health_bar.inv = true
	return burrow_distance
func clean_six(to_move,delta):
	if (get_last_beat() == 2):
		ground_pound(1,100)
	
	var parent = get_parent()
	#make sure that we collide with the burrow layer when we come up
	parent.collision_mask |= int(pow(2,5))
	parent.collision_mask |= int(pow(2,2))
	parent.collision_layer = 1
	
	var health = parent.get_node("health_bar")
	#remove our invulnerability and re-enable buffering
	health.inv = false
	health.do_buffer = true
var push_speed = 100
func ground_pound(dmg=1,rad=400):
	for i in get_tree().get_nodes_in_group("enemies"):
		if (to_global(position).distance_to(i.position) <= rad):
			if (i.has_method("move_and_collide")):
				var col = i.move_and_collide(make_dir(i.position-to_global(position))*push_speed)
				if (col):
					if (col.collider.has_method("on_col")):
						col.collider.on_col(self,dmg) 
					if (i.has_method("on_col")):
						i.on_col(self,dmg)
func flavor_changed(flavor):
	if flavor == 7 and $Sprite/AnimationPlayer.assigned_animation != "burrow":
			var player_health_bar = get_parent().get_node("health_bar")
			$Sprite/AnimationPlayer.play("burrow")
			$Sprite/burrow/Particles2D.emitting = true
func anim_finished(anim):
	if (running_7):
		running_7 = false
		$Sprite/AnimationPlayer.play("Ground_Pound")
	elif (anim == "Ground_Pound"):
		$groundPound.emitting = true
		$bang_back.emitting = true
		$bang_front.emitting = true
		ground_pound(dmg7)
		#go back to our idle state
		$Sprite/AnimationPlayer.play("Idle")
	else:
		.anim_finished(anim)
func _ready():
	.init()

func dir_anim(dir,prefix=""):
	if (running_7):
		.dir_anim(dir,"High_")
	else:
		.dir_anim(dir)
