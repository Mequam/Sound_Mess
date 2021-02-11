extends "res://scripts/abstracts/generic_static.gd"
#represents the number of enemies killed that we have animated for
var anim_killed : int = 0
#used to chache the total number of enemies killed
var total_killed : int = 0
#the bosses that we care about inteanded to be overloaded by others scripts
#or set in the scene tree
var bosses = ["inner_church_bunny-bunny_boss_entity","silo_boss_room-SiloBoss","statue_boss_room-StatueBoss"] #supposed to be a string array

var bossParticles = preload("res://scenes/assets/BossParticles.tscn")
#used to determine how many particles to spawn in conjunction with the timer
var toSpawn : int
func _ready():
	#load in the number of bosses which we have animated for (killed)
	$save_state_node.load_data()
	print("[blocker statue] anim_killed " + str(anim_killed))
	total_killed = $save_state_node.get_boss_kill_count(bosses)
	
	if total_killed < anim_killed:
		#this is a buged state that we SHOULD never be in,
		#but in case somthing goes wrong reset total_killed
		anim_killed = 0
	#we do not exist if we have animated all of our objects
	if anim_killed >= len(bosses):
		queue_free()
	elif total_killed > anim_killed:
		#we are going to run code when the parent is ready
		get_parent().connect("ready",self,"parent_ready")
		toSpawn = total_killed-anim_killed-1
	else:
		$Sprite.disconnect("animation_finished",self,"_on_Sprite_animation_finished")
		#note stateShrink0 does not exist, as the sprite starts in that state
		$Sprite.play("StateShrink" + str(anim_killed))
		$Sprite.play("Twitch"+str(anim_killed))

func spawn_particles(flying : bool = false):
	var bpi = bossParticles.instance()
	bpi.position = get_tree().get_nodes_in_group("player")[0].position
	bpi.flying = flying
	bpi.target_dir = $CamaraPoint.global_position
	bpi.connect("out_of_cam",self,"steal_camera")
	bpi.connect("arrived",bpi,"die_with_particles")
	bpi.connect("arrived",self,"run_next_anim")
	get_parent().add_child(bpi)

func parent_ready():
	spawn_particles()
	$Timer.start()

var cam_stolen : bool
func steal_camera()->void:
	#why pull the camera if its already here?
	#plus this lets the camera go out of focus of the object
	if not cam_stolen:
		$CamaraPoint.pull_player()
		cam_stolen = true

func run_next_anim():
	anim_killed += 1
	$Sprite.play("Shrink" + str(anim_killed))
#called when the sprite finishes animating, this is used to return the players camara
#and chain together our animations
func _on_Sprite_animation_finished(anim):
	#if it is not a state animation and there is another to kill, run the next animation
	if not (anim_killed < total_killed and anim.split("_")[0] != "StateShrink"):
		#save the fact that we animated those bosses
		$save_state_node.save_data()
		#play the appropriate twitch animation
		print("[blocker statue] finishing with anim_killed" + str(anim_killed))
		print("[blocker statue] playing Twitch" + str(anim_killed))
		$Sprite.play("Twitch" + str(anim_killed))
		#return the camara to it's proper position
		get_tree().get_nodes_in_group("player")[0].get_node("Camera2D").position = Vector2(0,0)
func _on_Timer_timeout():
	if toSpawn > 0:
		spawn_particles()
		toSpawn -= 1
	else:
		$Timer.stop()
