extends "res://scripts/bunnyOpeningDoor.gd"
#change the number of children that we use for this door
func _syncDisp():
	for i in range(2,charge+2):
		#display our charges
		if get_child(i):
			get_child(i).set_on(true)
		else:
			#no need to continue looping we have exhausted the number of children
			#we have
			break
	if charge >= get_child_count()-2:
		$Sprite.play("Open")
func _ready():
	pass
