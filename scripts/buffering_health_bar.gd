extends "res://scripts/health_bar.gd"

#this script is a health bar that optionally buffers after getting hit
#note that we have still not defined where we store the hp yet. That is inteanded
#to be defined by inherited children

#determines whether or not we use our buffering behavior
export var do_buffer : bool = true
func get_do_buffer() -> bool:
	return do_buffer
func set_inv(val : bool) -> void:
	if (val):
		#this is the name of the timer that we use to keep track of how long to buffer
		$Timer.start()
	.set_inv(val)
#wrapp the parent hp calculation to include a hook that 
#makes the hp invencible
func get_new_hp(new : int) -> int:
	var retVal = .get_new_hp(new)
	if do_buffer and new < get_hp():
		set_inv(true)
	return retVal

#undo buffering after we time out
#this is inteanded to be connected to a timer that waits for the proper amount of time
func _on_Timer_timeout():
	if do_buffer:
		set_inv(false)
