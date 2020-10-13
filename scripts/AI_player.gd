extends "res://scripts/player.gd"
#this signal fires when we finish iterating through the given loop
signal loop_finished
#this is a list of actions that we will be taking
var actions = [[1,2],[1,2],[2,2],[2,2],[2,2],[2,2]]
var offset = 0
#wether or not we want to loop our actions
var loop = true
func RythomToSpeed():
	return 60
func getActionId():
	if (len(actions) > 0):
		offset += 1
		if offset >= len(actions):
			emit_signal("loop_finished")
			if loop: # effectivly modulus
				offset = 0
			else:
				$Met.stop()
		var retVal = actions[offset][0]
		$Met.wait_time = actions[offset][1]*sub_beat
		return retVal
	return -1
func _ready():
	remove_from_group("player")
	add_to_group("AIplayer")
var stored_delta
func main_process(delta):
	stored_delta = delta
	limitNotePlayerTime(delta)
func _on_Met_timeout():
	find_input(stored_delta)
