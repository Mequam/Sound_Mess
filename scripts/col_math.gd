extends Object

#this function is used to shift collision bits to the right
#by the number of items in one layer cylce

#DESING NOTE:
#	Note for reference the games layer system is set up as follows
#	0 Boundry Tiles ,1 player,2 enemies, 3 terrain, 4 pickups, 5 player, 6 enemies...

#	think of these as layers within layers, when we multiply by 2 we shift
#	the bits to the right by the amount of times we multiply by 2

#	the wierd & here is to remove the first bit (boundry tile)
#	before multiplication as it DOES NOT rotate with everything else

#	we then add it back in at the end to make sure
static func shift_collision(collbits : int,amount : int) -> int:
	var nonCyclicBits : int  = get_constants(collbits) #2^3-1 to get 111b
	var onlyCyclics : int = collbits - nonCyclicBits
	return shift_bin_num(onlyCyclics,amount*Layer.size())+nonCyclicBits
	
	#shifts a binary number to the right or to the left by amount amount
static func shift_bin_num(collbit : int,amount : int) -> int:
	if amount >= 0:
		return collbit * int(pow(2,amount))
	return collbit / int(pow(2,(-amount)))

#returns the constant collision of a collision bit
static func get_constants(collbits : int) -> int:
	return collbits & (int(pow(2,ConstLayer.size()))-1) 
static func strip_constants(collbits : int) -> int:
	return collbits - get_constants(collbits)

#returns true if testbits is in layerbits
static func in_layer(testbits : int,layerbits : int) -> bool:
	#if they are in the layer then there will be at least 1 1 overlapping
	#and the result will not be zero
	return (testbits & layerbits) != 0	
#tests to see if the non constant bits match up to the given bits inside the given super layer
static func in_layer_no_constants(testbits : int,layerbits : int)->bool:
	return in_layer(strip_constants(testbits),strip_constants(layerbits))
#collision layer definitions

#These are the collision layers
enum Layer {
	PLAYER = 8,
	ENEMY = 16,
	TERRAIN = 32,
	PICKUPS = 64
}
#these are the layers that don't shift or have super classes
enum ConstLayer {
	TILE_BORDER = 1,
	PLAYER = 2,
	ALL_ENEMIES = 4
}
#these are our super class layers that are used with shifting
enum SuperLayer {
	MAIN = 0,
	BURROW = 1,
	FLIGHT = 2
	}
