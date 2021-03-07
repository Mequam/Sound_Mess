extends "res://scripts/swapperStatue.gd"
#reaaaaaly simple script that simply increaases the size of the statue inside
#of the avatar swapper by 5 times its previous value
func _ready():
	$AvatarSwapper.scale *= 5*0.75
	$AvatarSwapper.position += Vector2(0,50)
