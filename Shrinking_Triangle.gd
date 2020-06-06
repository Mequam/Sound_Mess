extends Sprite

var life = 5
var a = 1.0
func run():
	if (life == 0):
		queue_free()
	life -= 1
	scale/=2
	a/=2
	modulate = Color(1,1,1,a)
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("sprite_particle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
