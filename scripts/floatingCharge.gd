extends Node2D
var on : bool setget set_on,get_on
func set_on(val : bool):
	modulate = Color.white
	$AnimationPlayer.stop()
	if val:
		modulate = Color.green
		$AnimationPlayer.play("Idle")
func get_on()->bool:
	return $AnimationPlayer.is_playing("Idle")

func _ready():
	pass
