extends KinematicBody2D

#this counts up until it matches beat_val and then we run the code in run
var buff = 0 
#this represens how many of the "axiomatic" beat the player waited before sumoning the projectile
var beat_val = 1 setget set_beat_val,get_beat_val
func set_beat_val(val):
	match val:
		1:
			modulate = Color.white
			beat_life = 1
		2:
			modulate = Color.gray
			beat_life = 2
func get_beat_val():
	return beat_val
#how many rounds of life we move
var beat_life = 2
#how fast we can travel each round
var speed = 20

#this function ensures that the magnitude of the given vector is 1
func make_dir(v2):
	var n = 1.0/sqrt(v2.x*v2.x+v2.y*v2.y)
	return Vector2(n*v2.x,n*v2.y)
func dialate_speed(sub_beat,last_beat=null):
	if (last_beat == null):
		last_beat = beat_val
	$Shrinking_Triangle.dialate_speed(last_beat,sub_beat)

#setters and getters for the direction that the projectile travles
var dir = Vector2(0,0) setget set_dir,get_dir
func set_dir(val):
	$Shrinking_Triangle.position -= make_dir(val)*20
	dir = make_dir(val)
func get_dir():
	return dir
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("projectile")
	$Shrinking_Triangle.emit_dir(dir)

func run(player_position,beat):
	buff+=1
	if (buff == beat_val):
		var col = move_and_collide(dir*speed*50)
		if (col and col.collider.has_method("move_and_collide")):
			col.collider.move_and_collide(100*dir*speed/2)
		$Shrinking_Triangle.emit_dir(dir)
		beat_life -= 1
		if (beat_life <= 0):
			queue_free()
		buff = 0

func _on_push_zone_area_entered(area):
