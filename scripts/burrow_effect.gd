extends "res://scripts/abstracts/generic_area.gd"

func gen_col_layer():
	#we are on the burrow layer
	return col_math.shift_collision(col_math.Layer.PLAYER,col_math.SuperLayer.BURROW)
func gen_col_mask():
	#we hit any enemy on the burrow and above layer
	return col_math.shift_collision(col_math.Layer.ENEMY,col_math.SuperLayer.BURROW) | col_math.Layer.ENEMY
var trail = load("res://scenes/assets/burrow/burrow_trail.tscn")
var speed = 10000
var dir = Vector2(0,0)
var dist = 800
var init_pos
func _ready():
	$Timer.wait_time = 125.0/speed
	$Timer.start()
	init_pos = position
func _process(delta):
	position += dir*delta*speed
	if (init_pos.distance_to(position) >= dist):
		queue_free()
func _on_Timer_timeout():
	var inst = trail.instance()
	inst.position = position
	get_parent().add_child(inst)

func _on_burrow_effect_body_exited(body):
	if (body.has_method("on_col")):
		body.on_col(self,1)
