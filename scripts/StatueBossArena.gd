extends BunnyForest

func init():
	LoadData._player_ref = $player
	$ShowManTarantula.connect("super_corrupt",$pedastule/CentepidePreSprite,"corrupt")
	.init()

func _process(delta):
	if Input.is_key_pressed(KEY_D):
		get_node("CentipideBoss/CentipideBoss").die()
