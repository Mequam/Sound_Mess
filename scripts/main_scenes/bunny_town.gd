extends "res://scripts/abstracts/bunny_forest.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$door_to_tall_grass.door_name = "B"
	$door_to_tall_grass.new_scene = "res://scenes/main/bunny/grass_field.tscn"
	var first_motif = [[0,2],[4,2],[2,1],[0,1],[2,1],
					[0,1],[null,1],[2,1],[null,1],
					[4,1],[2,1],[-1,1],[0,2]]
	var first_motif_long = [[0,4],[4,4],[2,4],[0,4],
						[2,4],[0,4],[2,4],[4,4],[2,4]]
	var first_motif_fast_end = [[4,1],[2,1],[-1,1],[1,1],
								[null,1],[1,1],[4,1],[-1,1],
								[2,1],[-1,1],[3,1],[1,1],[4,1],[6,1],
								[0,1]]
	var snd_motif = [[3-7,1],[null,1],[5-7,1],[null,1],
					[3-7,1],[null,1],[5-7,1],
					[null,1],[3-7,1],[5-7,1],[3-7,1],
					[null,1],[4-7,1],[0,1],[null,1],[0,1]]
	var snd_motif_mutate = [[5-7,1],[null,1],[7-7,1],[null,1],
							[4-7,1],[null,1],[6-7,1],
							[null,1],[6-7,1],[5-7,1],[3-7,1],
							[4-7,1],[null,1],[7-7,1],[6-7,1],[7-7,1]]
	var snd_motif_mutate2 = [[-7,1],[2-7,1],[3-7,1],[5-7,1]]
	
	var snd_motif_fast_end = [[-4,1],[-2,1],[-4,1],[-2,1],[-4,1],[-2,1],[null,1],[-4,1],[-3,1],[null,1],[0,1],[-1,1],[0,1]]
	snd_motif_mutate2 = snd_motif_mutate2 + snd_motif_mutate2 + [[0,1]]
	
	$AI_player._permatalk = true
	$AI_player.actions = first_motif+[[null,16]]+snd_motif
	

							#32 is the length of the first motif, so we wait
							#till that motif is over and play the second
	$AI_player2._permatalk = true
	$AI_player2.actions = [[null,16]]+snd_motif+[[null,16]]+first_motif
	$AI_player2/avatar/Sprite/AnimationPlayer.play("Idle_Left")
	$AI_player3._permatalk = true
	$AI_player3.actions	= [[null,32]]+first_motif+[[null,16]] + first_motif_fast_end
	
	$AI_player8._permatalk = true
	$AI_player8.actions = [[null,64]]+first_motif_long
	
	$AI_player4.actions	= [[null,32]]+[[1,2],[4,2],[1,2],[4,2],[2,2],[3,1],[2,1],[3,1],[7,1]]
	$AI_player5.actions = [[1,1],[6,1],[4,1],[0,1]]+[[null,64]]+[[4,1],[6,1],[1,1],[0,1]]
	.init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
