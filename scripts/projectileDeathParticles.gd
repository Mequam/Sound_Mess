extends Particles2D

class_name ProjectileDeathParticles

#a more sofisticated method would do more than just triggere an animation player
#but this works for most general cases
func emit_dir(given_dir : Vector2)->void:
	$AnimationPlayer.play("emit")
func _ready():
	#we die once we finish emiting and for some strange reason Particles2D doesnt
	#have a signal to link so we use a timed animation for that
	$AnimationPlayer.connect("animation_finished",self,"queue_free")

