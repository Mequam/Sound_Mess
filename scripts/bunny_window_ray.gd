extends Node2D


func _ready():
	$ParallaxBackground/mid_layer/mid_triangle.modulate = modulate
	$ParallaxBackground/top_layer/top_triangle.modulate = modulate
