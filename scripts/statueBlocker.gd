extends "res://scripts/abstracts/generic_static.gd"
#represents the number of enemies killed that we have animated for
var anim_killed : int = 0
#used to chache the total number of enemies killed
var total_killed : int = 0
#the bosses that we care about inteanded to be overloaded by others scripts
#or set in the scene tree
var bosses = ["inner_church_bunny-bunny_boss_entity","silo_boss_room-SiloBoss","statue_boss_room-StatueBoss"] #supposed to be a string array

var bossParticles = preload("res://scenes/assets/BossParticles.tscn")
func spawn_particles():
	var bpi = bossParticles.instance()
	bpi.position = get_tree().get_nodes_in_group("player")[0].position
	bpi.flying = false
	bpi.target_dir = $CamaraPoint.global_position
	bpi.position = get_tree().get_nodes_in_group("player")[0].position
	return bpi

func _ready():
	#load in the number of bosses which we have animated for (killed)
	$save_state_node.load_data()
	total_killed = $save_state_node.get_boss_kill_count(bosses)
	
	if total_killed < anim_killed:
		#this is a buged state that we SHOULD never be in,
		#but in case somthing goes wrong reset total_killed
		anim_killed = 0
	#we do not exist if the player has killed three things
	if anim_killed >= len(bosses):
		queue_free()
	elif total_killed != anim_killed:
		#set up our state to represent the number of enemies which have been killed
		#and their animations displayed
		#make connect our animation player
		$Sprite.connect("animation_finished",self,"anim_finished")
		
		get_parent().connect("ready",self,"parent_ready")
	else:
		$Sprite/guard_legs/AnimationPlayer.play("Twitch")
func parent_ready():
	var spawned_particle = spawn_particles()
	spawned_particle.connect("out_of_cam",$CamaraPoint,"pull_player")
	spawned_particle.connect("arrived",$CamaraPoint,"pull_player")
	get_parent().add_child(spawned_particle)
func run_next_anim():
	anim_killed += 1
	print("playing Shrink" +str(anim_killed))
	$Sprite.play("Shrink" + str(anim_killed))
func _on_CamaraPoint_camara_arrived(cam):
	run_next_anim()
func _on_Sprite_animation_finished(anim):
	#if it is not a state animation and there is another to kill, run the next animation
	if anim_killed < total_killed and anim.split("_")[0] != "StateShrink":
		run_next_anim()
	else:
		print("stopping animations")
		#return the camara to it's proper position
		get_tree().get_nodes_in_group("player")[0].get_node("Camera2D").position = Vector2(0,0)
