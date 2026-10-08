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

const P1UP = "up"
const P1DOWN = "down"
const P1LEFT = "left"
const P1RIGHT = "right"
const P1HIT = "hit"
const P1HEAVY_HIT = "heavyHit"
const P1BLOCK = "block"
const P1DASH = "dash"
const P1QUICKSLOTBOT = "quickSlotBottom"
const P1QUICKSLOTTOP = "quickSlotTop"
const P1QUICKSLOTLEFT = "quickSlotLeft"
const P1QUICKSLOTRIGHT = "quickSlotRight"
const P1INTERACT = "interact"

const P2UP = "up2"
const P2DOWN = "down2"
const P2LEFT = "left2"
const P2RIGHT = "right2"
const P2HIT = "hit2"
const P2HEAVY_HIT = "heavyHit2"
const P2BLOCK = "block2"
const P2DASH = "dash2"
const P2QUICKSLOTBOT = "quickSlotBottom2"
const P2QUICKSLOTTOP = "quickSlotTop2"
const P2QUICKSLOTLEFT = "quickSlotLeft2"
const P2QUICKSLOTRIGHT = "quickSlotRight2"
const P2INTERACT = "interact2"
