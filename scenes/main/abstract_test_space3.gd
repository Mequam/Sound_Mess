extends Node2D

func _input(event):
	if event is InputEventMouseMotion:
		$CentipiedeMotor.velocity = event.position-$CentipiedeMotor.position
