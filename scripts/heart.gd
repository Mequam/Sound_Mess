extends Node2D

signal lost_heart

var hp = 0 setget set_hp,get_hp
func set_hp(val):
	if (val <= 0):
		emit_signal("lost_heart")
		#remove ourselfs from the tree
		queue_free()
		return false
	elif (val <= 2):
		hp = val
	elif (val > 2):
		hp = 2
	sync_hp()
	return true

func get_hp():
	return hp

#makes sure that the heart displays the value that it contains
func sync_hp():
	if hp >= 2:
		$heart/top.visible = true
	else:
		$heart/top.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ui")
	add_to_group("heart")
	sync_hp()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
