extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ev = InputEventAction.new()
var i = 0
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("NotePlayer").mode=1
	for val in InputMap.get_actions():
		print(str(val))
	get_node("NotePlayer").play_note(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(0,8):
		if (Input.is_action_just_pressed("NOTE_"+str(i))):
			get_node("NotePlayer").play_note(i)
			break
	if (Input.is_key_pressed(KEY_SPACE)):
		get_node("NotePlayer").mode = (get_node("NotePlayer").mode + 1) % 7
		print('[DEBUG] running in ' + str(get_node("NotePlayer").mode))
