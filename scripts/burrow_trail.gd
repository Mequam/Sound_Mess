extends Particles2D

func _ready():
	emitting = true
func _process(delta):
	#die if we are not emmiting
	if !emitting:
		queue_free()
