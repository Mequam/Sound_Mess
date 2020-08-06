extends Node2D


var window_color setget set_window_color,get_window_color
func set_window_color(val):
	$inner.modulate = val
func get_window_color():
	return $inner.modulate

# Called when the node enters the scene tree for the first time.
func _ready():
	set_window_color(Color.yellow)
	$AnimationPlayer.play("Idle")
