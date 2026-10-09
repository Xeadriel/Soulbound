extends Node

# This global script defines shared constants, enums, and other reusable definitions
# used across multiple scripts, providing a single source of truth to simplify
# maintenance and ensure changes only need to be made in one location.

enum ItemIndices {
	NOTHING, # TODO: make locations where we find 'nothing' but its 
			 # actually an item thats tracked with an achievement 
	WHIP,
	POTION,
	SMALL_KEY,
	PIECES_OF_EIGHT
	# insert new items here
}

enum QuickSlotIndices {
	BOTTOM,
	TOP,
	LEFT,
	RIGHT
}
