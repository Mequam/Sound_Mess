extends "res://scripts/avatar.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()

var push_proj_package = load("res://scenes/instance/projectiles/pushProjectile.tscn")
func run_six(to_move,delta):
	var proj = push_proj_package.instance()
	proj.beat_val = get_parent().last_beat
	proj.dialate_speed(get_parent().sub_beat)
	proj.dir = to_move
	#TODO: figure out why this position needs to be shifted! (without the shift the projectile spawns in the wrong spot DESPITE beign at 0,0 in our chords)
	proj.position = to_global(position)
	proj.speed = get_parent().speed/2
	get_tree().get_root().add_child(proj)
	return 1


var attack_dir_pkg = load("res://scenes/instance/projectiles/attack_proj.tscn")
#this function is in charge of our push effect
func run_seven(dir,delta):
	var last_beat = get_last_beat()
	var proj = attack_dir_pkg.instance()
	proj.scale *= last_beat*2
	proj.speed = 400*last_beat
	proj.dir = dir
	if (last_beat == 2):
		proj.modulate = Color.lightgray
	var offset = make_dir(dir)*30
	#this creates a dead zone around the player sprite so that the projectile never touches them
	if (offset.x < 10 and offset.x > -10 and offset.y < 30 and offset.y > -40):
		if (offset.y-30 > offset.y+60):
			offset.y = 30
		else:
			offset.y = -60
	proj.position = to_global(position) + offset
	proj.position
	get_tree().get_root().add_child(proj)
	return 0
#plays the proper animation for moving in the given direction
func dir_anim(dir,prefix=""):
	var sub_beat = get_sub_beat()
	var last_beat = get_last_beat()
	
	if (dir.y < 0):
		#emit up
		$Sprite.emit_up(last_beat,sub_beat)
	elif (dir.y > 0):
		#emit down
		$Sprite.emit_down(last_beat,sub_beat)
	else:
		$Sprite.emit_horizontal(last_beat,sub_beat)
		if (dir.x > 0):
			get_node("Sprite").flip_h = false
			get_node("Sprite/AnimationPlayer").play("Slide")
		elif (dir.x < 0):
			#trick the node into playing its animation backwords
			get_node("Sprite").flip_h = true
			get_node("Sprite/AnimationPlayer").play("Slide")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
