extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!emitting):
		queue_free()
