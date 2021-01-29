extends KinematicBody2D
#this script is ment to code behavior of any knimatic body that moves 
#around and has a health bar

#emitted when the entity dies
signal die
const col_math = preload("res://scripts/col_math.gd")

#add entities to the entity group
func _ready() -> void:
	#all entities are in group entities
	add_to_group("entities")
	#all entities or their masks
	collision_layer |= gen_col_layer()
	collision_mask |= gen_col_mask()
	#all entities run main_ready
	main_ready()

#generic on collision function
#this is intended to be called by entities when they hit us
func on_col(obj,dmg : int) -> void:
	take_damage(dmg)

#generic function called when the entity dies
func die() -> void:
	emit_signal("die",self)
	queue_free()

#setter getters for hp note we do not store the hp value in this node
#instead it comes from the health bar which is our child
func set_hp(val : int) -> void:
	$health_bar.hp = val
	if $health_bar.hp <= 0:
		die()
func get_hp() -> int:
	return $health_bar.hp

#the following two functions (take_damage and heal) are syntactic sugar only
#function that indicates the player takes damage
func take_damage(amount : int) -> void:
	set_hp(get_hp()-amount)
#function that indicates the player heals
func heal(amount : int) -> void:
	set_hp(get_hp()+amount)

#these functions are used to generate or masks for the 
#collision layer and collision mask

#think of them as saying "all of this class is on layer and collides with"
#if there are exceptions to this rule they need to be added in inherited code 
func gen_col_layer()->int:
	return 0
func gen_col_mask()->int:
	return col_math.ConstLayer.TILE_BORDER #all entities collide with the border tile

#this function is designed to be overloadable by
#child classes and is run one time on _ready
#the default ready behavior is to check and load the 
#state of the entity
func main_ready()->void:
	pass
