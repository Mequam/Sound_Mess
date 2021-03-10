extends Node2D
#this script serves as display behavior for the zone locking
#statues
signal animation_finished

#pass on the animation_finished signal 
func _ready():
	$guard_legs/AnimationPlayer.connect("animation_finished",self,"emit_finished")
func emit_finished(anim):
	emit_signal("animation_finished",anim)
#play an animation
func play(anim : String):
	$guard_legs/AnimationPlayer.play(anim)
	$guard_legs2/AnimationPlayer.play(anim)
