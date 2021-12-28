extends BunnyForest

func init():
	$ShowManTarantula.connect("super_corrupt",$pedastule/CentepidePreSprite,"corrupt")
	.init()

func _process(delta):
	if Input.is_key_pressed(KEY_A):
		$CentepidePreSprite.corrupt()
	elif Input.is_key_pressed(KEY_R):
		get_node("CentipideBoss/CentipideBoss").circle_mode_change(500,900)
	elif Input.is_key_pressed(KEY_C):
		get_node("CentipideBoss/CentipideBoss")._circle_rotation_dir = 1
	elif Input.is_key_pressed(KEY_O):
		get_node("CentipideBoss/CentipideBoss")._circle_rotation_dir = -1
