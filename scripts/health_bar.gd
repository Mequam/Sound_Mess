extends Node2D

var heart = load("res://scenes/instance/half_heart.tscn")

var hp = 1 setget set_hp,get_hp
func set_hp(val):
	if (val < 0):
		val = 0
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
		children.queue_free()
	#add the remaining hearts
	for i in range(0,int(hp)/int(2)):
		add_heart()
	#this includes the remainder points
	add_heart(hp%2)
