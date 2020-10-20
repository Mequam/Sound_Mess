extends Node2D

func _ready():
	$note_base.display_degree = 0
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			$note_base.display_degree = ($note_base.display_degree+1)%8
			print($note_base.display_degree)
