extends Node2D

var heart = load("res://scenes/instance/half_heart.tscn")
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

#functions designed to be overloaded by more specific classes
func get_hp() -> int :
	return 0
#call sync display when setting hp normaly
func set_hp(val : int) -> void:
	sync_disp()

#this function is the logic for changing whatever value we store our hp as
#it is designed to be encapsulated by child classes which change
#where exactly that data is stored

#NOTE: if encapsulating this function, you need to sync the display
#after changing the source of the hp by calling sync_disp

#alternativly you could simply call the parent set_hp after yours and the display will
#be synced
func get_new_hp(newVal,oldVal):
	if (!buffering):
		if (newVal < 0):
			newVal = 0
		if (newVal < oldVal and do_buffer):
			set_buffering(true)
		return newVal
	return oldVal
	
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
	for i in range(0,get_hp()/int(2)):
		add_heart()
	#this includes the remainder points
	add_heart(get_hp()%2)
func _ready():
	add_to_group("ui")
	add_to_group("health_bar")

func _on_iframe_timeout_timeout():
	buffering = false
