extends Node2D
#this script spawns the statue enemy and prepares it for animation when the pre centipuide sprite finishes

var centipide_boss = preload("res://scenes/instance/entities/enemies/bosses/bunny/CentipideBoss.tscn")
func _ready():
	if $save_state_node.read_data_path("user://game" + $save_state_node.get_game_save_file() +"/"+ get_parent().owner.name +"-CentipideBoss.dat").has("mode"):
		queue_free()
func corrupt():
	$AnimationPlayer.play("Transform")
func _on_AnimationPlayer_animation_finished(anim_name):
	var inst = centipide_boss.instance()
	inst.global_position = global_position
	get_parent().get_parent().add_child(inst)
	inst.owner = get_parent().get_parent()
	queue_free()
