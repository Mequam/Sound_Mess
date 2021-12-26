extends "res://scripts/abstracts/generic_enemy.gd"

class_name Boss

var death_particles = preload("res://scenes/assets/BossParticles.tscn")
func die():
	var d_inst = death_particles.instance()
	d_inst.position = position+Vector2(0,1)
	get_parent().add_child(d_inst)
	
	#do not remove us from the tree, instead set our mode to dead 
	if $Sprite:
		$Sprite/AnimationPlayer.play("Die")
	remove_from_group("enemies")
	mode = "dead"
	emit_signal("die")
	
	$save_state_node.save_death()
