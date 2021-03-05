extends Particles2D
#very simple asset script to route the emit dir through to the emitting
#property of particles for use with the projectile classes
func emit_dir(dir : Vector2):
	emitting = true
