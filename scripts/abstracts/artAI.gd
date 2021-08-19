extends GenericKinematic

class_name ArtAI

#this script is for AI that does nothing but look pretty and mabye interact with the player
#when they get close

func gen_col_mask()->int:
	return col_math.ConstLayer.TILE_BORDER | col_math.Layer.TERRAIN
func gen_col_layer()->int:
	return 0

#the mode of the AI which is a very simple state machine
var mode : String = "Idle" setget set_mode,get_mode
func set_mode(string : String)->void:
	match string:
		"Away":
			$Sprite/AnimationPlayer.play("Away")
		"Idle":
			$Sprite/AnimationPlayer.play("Idle")
	mode = string
func get_mode()->String:
	return mode

#submodes for inner modal usage
#the idea is you could have an attack mode with sub modes fast and slow
#that is BASICALY the same thing so you can avoid calling the set mode while in a mode
var subMode : String = "Left" setget set_subMode,get_subMode
func set_subMode(string : String)->void:
	match subMode:
		"Right":
			if string == "Left":
				$Sprite.scale.x = abs($Sprite.scale.x)
			inner_beat = 0
		"Left":
			if string == "Right":
				$Sprite.scale.x = -1*abs($Sprite.scale.x)
			inner_beat = 0
	subMode = string

#misclanious counter for modal usage
var inner_beat : int = 0

func get_subMode()->String:
	return subMode

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("art_ai")
	#make sure whatever hooks are in the set mode for this state fire
	set_mode("Idle")
	set_subMode("Left")
	$Sprite/AnimationPlayer.connect("animation_finished",self,"anim_finished")

func anim_finished(anim):
	match anim:
		"Away":
			queue_free()
#basic movement of the ai, inteanded to be overloaded
func move():
	match subMode:
				"Right":
					if move_and_collide(Vector2(2,0)):
						set_subMode("Left")
				"Left":
					if move_and_collide(Vector2(-2,0)):
						set_subMode("Right")

#called by the parent node every few beats with the player position
func run(player_pos : Vector2,beat):
	match mode:
		"Idle":
			inner_beat += 1
			move()
			if player_pos.distance_squared_to(position) < 100000:
				set_mode("Away")
			if inner_beat >= 64:
				if get_subMode() == "Right":
					set_subMode("Left")
				else:
					set_subMode("Right")
