extends "res://scripts/abstracts/bunny_forest.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$door_to_tall_grass.door_name = "B"
	$door_to_tall_grass.new_scene = "res://scenes/main/bunny/grass_field.tscn"
	var first_motif = [[0,4],[4,4],[2,2],[0,2],[2,2],
					[0,2],[null,2],[2,2],[null,2],
					[4,2],[2,2],[-1,2],[0,4]]
	var snd_motif = [[3-7,2],[null,2],[5-7,2],[null,2],
					[3-7,2],[null,2],[5-7,2],
					[null,2],[3-7,2],[5-7,2],[3-7,2],
					[null,2],[4-7,2],[0,2],[null,2],[0,2]]
	var snd_motif_mutate = []
	
	$AI_player._permatalk = true
	$AI_player.actions = first_motif + first_motif+first_motif
	
	$AI_player2._permatalk = true
							#32 is the length of the first motif, so we wait
							#till that motif is over and play the second
	$AI_player2.actions = [[null,32]]+snd_motif+snd_motif
	.init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
