extends Object
#this script contains all of the math and translation functions
#required to work with the Avatars enumerator and the code
#stored inside of each avatar
enum Avatars {
	ARCH, #lydian
	BUNNY, #major
	BIRD #mixolidian
}
static func isAvatarCode(avatar_enum : int)->bool:
	return 0 <= avatar_enum and avatar_enum < Avatars.size()
#converts an avatar enumerator into the path where that avatar is stored
static func avatar_enum2path(avatar_enum : int)-> String:
	if isAvatarCode(avatar_enum):
		return ["",
		"res://scenes/instance/avatars/bunny_avatar.tscn",
		"res://scenes/instance/avatars/bird_avatar.tscn"][avatar_enum]
	return "res://scenes/instance/avatars/bunny_avatar.tscn" #defualt to the bunny path to avoid errors
#converts an avatar enumerator to the path to the transformer statue
static func avatar_enum2transPath(avatar_enum : int) -> String:
	if isAvatarCode(avatar_enum):
		return ["",
		"res://scenes/assets/avatar_swapper_statues/bunnySwapperStatue.tscn",
		"res://scenes/assets/avatar_swapper_statues/birdTransformationStatue.tscn"][avatar_enum]
	#default to the bunny
	return "res://scenes/assets/avatar_swapper_statues/bunnySwapperStatue.tscn"
#converts an avatar enumerator to the node that the avatar swapper statue is located at
static func avatar_enum2transNode(avatar_enum : int) -> String:
	return load(avatar_enum2transPath(avatar_enum)).instance()
	
#gets the path of a normal statue for any given avatar
static func avatar_enum2statuePath(avatar_enum : int) -> String:
	if isAvatarCode(avatar_enum):
		return ["",
			"res://scenes/assets/architecture/bunny/statue.tscn",
			"res://scenes/assets/architecture/bird/birdStatue.tscn"
		][avatar_enum]
	#default to the rabbit on error
	return "res://scenes/assets/architecture/bunny/statue.tscn"
#gets a loaded node of the given statue
static func avatar_enum2statueNode(avatar_enum : int)-> Node:
	return load(avatar_enum2statuePath(avatar_enum)).instance()
