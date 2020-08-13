extends "res://scripts/abstracts/scene.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_path = "res://scenes/main/test_scene_2.tscn"
	$SingingTree/door_way.door_name="A"
	$SingingTree/door_way.new_scene = "res://scenes/main/test_2d_space.tscn"
	$player/NotePlayer.mode = 1
	.init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		$bunny_boss_entity.mode = "move_burrow" if $bunny_boss_entity.mode == "move_circle" else "move_circle"
