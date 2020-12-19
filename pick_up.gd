extends Area2D

signal player_enterd
func _ready():
	pass
var type = "generic"
func _on_Pick_Up_ody_entered(body):
	if (body.is_in_group("player")):
		emit_signal("player_enterd",self)
		
