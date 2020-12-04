extends Node2D
#this script represents the generic switch class

#emited when we update to a different state
signal state_changed
#emitted when we update the state
signal state_updated

var on : bool setget set_on,get_on
func set_on(val : bool):
	if (val != on):
		emit_signal("state_changed",val)
	on=val
	emit_signal("state_updated",on)
func get_on():
	return on
