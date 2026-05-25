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
var INTERACT = "interact"

# State Names
const STATEIDLE = "StateIdle"
const STATERUN = "StateRun"
const STATEATTACK = "StateAttack"
const STATEHEAVYATTACK = "StateHeavyAttack"
const STATEBLOCK = "StateBlock"
const STATEDASH = "StateDash"
const STATEWHIPATTACK = "StateWhipAttack"
const STATEINTERACTING = "StateInteracting"

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
		UP = GlobalConstants.P1UP
		DOWN = GlobalConstants.P1DOWN
		LEFT = GlobalConstants.P1LEFT
		RIGHT = GlobalConstants.P1RIGHT
		HIT = GlobalConstants.P1HIT
		HEAVY_HIT = GlobalConstants.P1HEAVY_HIT
		BLOCK = GlobalConstants.P1BLOCK
		DASH = GlobalConstants.P1DASH
		QUICKSLOTBOT = GlobalConstants.P1QUICKSLOTBOT
		QUICKSLOTTOP = GlobalConstants.P1QUICKSLOTTOP
		QUICKSLOTLEFT = GlobalConstants.P1QUICKSLOTLEFT
		QUICKSLOTRIGHT = GlobalConstants.P1QUICKSLOTRIGHT
		INTERACT = GlobalConstants.P1INTERACT
	elif player is Player2:
		UP = GlobalConstants.P2UP
		DOWN = GlobalConstants.P2DOWN
		LEFT = GlobalConstants.P2LEFT
		RIGHT = GlobalConstants.P2RIGHT
		HIT = GlobalConstants.P2HIT
		HEAVY_HIT = GlobalConstants.P2HEAVY_HIT
		BLOCK = GlobalConstants.P2BLOCK
		DASH = GlobalConstants.P2DASH
		QUICKSLOTBOT = GlobalConstants.P2QUICKSLOTBOT
		QUICKSLOTTOP = GlobalConstants.P2QUICKSLOTTOP
		QUICKSLOTLEFT = GlobalConstants.P2QUICKSLOTLEFT
		QUICKSLOTRIGHT = GlobalConstants.P2QUICKSLOTRIGHT
		INTERACT = GlobalConstants.P2INTERACT

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
