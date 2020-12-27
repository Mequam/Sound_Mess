extends Node2D

var heart = load("res://scenes/instance/half_heart.tscn")

#if this is true we gray out the health display
#and accept no further damage
var inv = false setget set_inv,get_inv
func set_inv(val : bool)->void:
	inv = val
	if (inv):
		modulate = Color.darkgray
	else:
		modulate = Color.red
func get_inv()->bool:
	return inv

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
func get_new_hp(newVal : int) -> int:
	#if we are invulnerable hp does not change
	if inv:
		return get_hp()
	#hp is never negative
	if (newVal < 0):
		newVal = 0
	return newVal
	
#used to keep track of the x position of the last heart (so we can instance new ones)
var last_heart_position = 0
func add_heart(val = 3):
	var heart_d = heart.instance()
	heart_d.position.x = last_heart_position
	last_heart_position += 20
	heart_d.hp = val
	add_child(heart_d)

#syncs the display to match the hp sourcce
func sync_disp():
	last_heart_position = 0
	#free the exiting children
	for children in get_children():
		if (children.name != "Timer"):
			children.queue_free()
	#add the remaining hearts
	for i in range(0,get_hp()/int(2)):
		add_heart()
	#this includes the remainder points
	add_heart(get_hp()%2)

#set up the groups
func _ready():
	add_to_group("ui")
	add_to_group("health_bar")
