extends Area2D


func _ready():
	pass


func _on_poof_grass_body_entered(body):
	$tall_grass/Particles2D.emitting = true
