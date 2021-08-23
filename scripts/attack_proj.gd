extends Area2D

var dir = Vector2(0,0) setget set_dir,get_dir
func set_dir(val):
	dir = make_dir(val)
	rotation = create_rot(dir)
func get_dir():
	return dir

func make_dir(v2):
	var n = 1.0/sqrt(v2.x*v2.x+v2.y*v2.y)
	return Vector2(n*v2.x,n*v2.y)
func create_rot(dir):
	var neg = 1 if dir.y >= 0 else -1
	return acos(dir.x)*neg-PI/2
var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=dir*speed*delta
func _ready():
	$AnimationPlayer.play("Attack")
func run(player_position,beat):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_Node2D_body_entered(body):
	if (body.has_method("on_col")):
		body.on_col(self)
