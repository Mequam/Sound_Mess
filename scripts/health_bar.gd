extends Node2D

var heart = load("res://scenes/instance/half_heart.tscn")

var hp = 1 setget set_hp,get_hp
var buffering = false setget set_buffering,get_buffering
func set_buffering(val):
	buffering = val
	if (buffering):
		$iframe_timeout.start()
func get_buffering():
	return buffering
func un_buffer():
	buffering = false
var do_buffer = true
func set_hp(val):
	if (!buffering):
		if (val < 0):
			val = 0
		if (val < hp and do_buffer):
			set_buffering(true)
		hp = val
		sync_disp()
func get_hp():
	return hp

#used to keep track of the x position of the last heart (so we can instance new ones)
var last_heart_position = 0
func add_heart(val = 3):
	var heart_d = heart.instance()
	heart_d.position.x = last_heart_position
	last_heart_position += 20
	heart_d.hp = val
	add_child(heart_d)

#syncs the display to match the hp
func sync_disp():
	last_heart_position = 0	
	#free the exiting children
	for children in get_children():
		if (children.name != "iframe_timeout"):
			children.queue_free()
	#add the remaining hearts
	for i in range(0,int(hp)/int(2)):
		add_heart()
	#this includes the remainder points
	add_heart(hp%2)
func _ready():
	add_to_group("ui")
	add_to_group("health_bar")

func _on_iframe_timeout_timeout():
	buffering = false
