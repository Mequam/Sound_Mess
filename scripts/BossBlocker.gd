extends Node2D
#this script serves as display behavior for the zone locking
#statues
signal animation_finished

#pass on the animation_finished signal 
func _ready():
	#this strange operation makes the gaurd legs child the last oredered node
	#in our children
	#we use this to make them apear in front of the sprite which is added in the scene
	var glegs = $guard_legs
	remove_child(glegs)
	add_child(glegs)
	
	$guard_legs/AnimationPlayer.connect("animation_finished",self,"emit_finished")
func emit_finished(anim):
	emit_signal("animation_finished",anim)
#play an animation
func play(anim : String):
	$guard_legs/AnimationPlayer.play(anim)
	$guard_legs2/AnimationPlayer.play(anim)
