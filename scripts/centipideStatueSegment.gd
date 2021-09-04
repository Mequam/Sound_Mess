extends GenericStatic

#we exist on the enemy layer despite not moving
#this way the player runs into us and the enemies ignore us
func gen_col_layer():
	return col_math.Layer.ENEMY
