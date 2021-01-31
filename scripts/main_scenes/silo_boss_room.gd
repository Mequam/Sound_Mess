extends "res://scripts/abstracts/bunny_forest.gd"
func init():
	$silo_fields_door.door_name = "A"
	$silo_fields_door.new_scene = "res://scenes/main/bunny/carrot_motif/silo_fields.tscn"

	#load in weather or not this is actually our first visit
	var silo_state_dict = $SiloBoss/save_state_node.read_data_path($SiloBoss/save_state_node.get_save_path())
	
	#if the boss is already dead cancel the animations
	if silo_state_dict.has("dead") and silo_state_dict.dead:
		$Tarantula.queue_free()
		$SiloBoss/VisibilityNotifier2D.queue_free()
	#run the parent init
	.init()


func _on_VisibilityNotifier2D_screen_entered():
	$Tarantula.can_corrupt = true
	$Tarantula.mode = "Alert"
	$SiloBoss.corrupt()
	#no more visibility notifications
	$SiloBoss/VisibilityNotifier2D.queue_free()
