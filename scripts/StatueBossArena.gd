extends BunnyForest

func init():
	$ShowManTarantula.connect("super_corrupt",$pedastule/CentepidePreSprite,"corrupt")
	.init()

func _process(delta):
	if Input.is_key_pressed(KEY_D):
		get_node("CentipideBoss/CentipideBoss").die()
