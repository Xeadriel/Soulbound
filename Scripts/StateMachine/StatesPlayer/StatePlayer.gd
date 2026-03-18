class_name StatePlayer extends State

@export var player : Player = null

# input actions
var UP = "up"
var DOWN = "down"
var LEFT = "left"
var RIGHT = "right"
var HIT = "hit"
var HEAVY_HIT = "heavyHit"
var BLOCK = "block"
var DASH = "dash"
var QUICKSLOTBOT = "quickSlotBottom"
var QUICKSLOTTOP = "quickSlotTop"
var QUICKSLOTLEFT = "quickSlotLeft"
var QUICKSLOTRIGHT = "quickSlotRight"

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func _ready() -> void:
	assert(player != null, "don't forget to assign a player to the state")
	assert(player is Player1 or player is Player2, "player must be either one of the player classes")
	
	if player is Player1:
		UP = "up"
		DOWN = "down"
		LEFT = "left"
		RIGHT = "right"
		HIT = "hit"
		HEAVY_HIT = "heavyHit"
		BLOCK = "block"
		DASH = "dash"
		QUICKSLOTBOT = "quickSlotBottom"
		QUICKSLOTTOP = "quickSlotTop"
		QUICKSLOTLEFT = "quickSlotLeft"
		QUICKSLOTRIGHT = "quickSlotRight"
	elif player is Player2:
		UP = "up2"
		DOWN = "down2"
		LEFT = "left2"
		RIGHT = "right2"
		HIT = "hit2"
		HEAVY_HIT = "heavyHit2"
		BLOCK = "block2"
		DASH = "dash2"
		QUICKSLOTBOT = "quickSlotBottom2"
		QUICKSLOTTOP = "quickSlotTop2"
		QUICKSLOTLEFT = "quickSlotLeft2"
		QUICKSLOTRIGHT = "quickSlotRight2"

## Called by the state machine when receiving unhandled input events.
func handleInput() -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
