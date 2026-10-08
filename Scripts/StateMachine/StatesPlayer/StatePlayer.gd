class_name StatePlayer extends State
## Base class for player states. Gives access to the player, their input actions
## and the shared action-button handling.

@export var player : Player = null

# State Names
const STATEIDLE = "StateIdle"
const STATERUN = "StateRun"
const STATEATTACK = "StateAttack"
const STATEHEAVYATTACK = "StateHeavyAttack"
const STATEBLOCK = "StateBlock"
const STATEDASH = "StateDash"
const STATEWHIPATTACK = "StateWhipAttack"
const STATEINTERACTING = "StateInteracting"

## Order in which quick slot buttons are checked when several are pressed at once.
const QUICK_SLOT_ORDER : Array[GlobalConstants.QuickSlotIndices] = [
	GlobalConstants.QuickSlotIndices.BOTTOM,
	GlobalConstants.QuickSlotIndices.TOP,
	GlobalConstants.QuickSlotIndices.LEFT,
	GlobalConstants.QuickSlotIndices.RIGHT,
]

## The input actions of the player this state belongs to.
var input : PlayerInputProfile:
	get:
		return player.inputProfile

func _ready() -> void:
	if player == null:
		player = owner as Player
	assert(player != null, "don't forget to assign a player to the state")

## Checks the action buttons in priority order: hit, heavy hit, dash, quick slots,
## interact. Returns true if one of them was pressed (the press is consumed even if
## it did not lead to a transition, e.g. interact with nothing nearby).
func handleActionInputs() -> bool:
	if InputBuffer.consumePress(input.hit):
		transition(STATEATTACK)
	elif InputBuffer.consumePress(input.heavyHit):
		transition(STATEHEAVYATTACK)
	elif InputBuffer.consumePress(input.dash):
		transition(STATEDASH)
	elif consumeQuickSlotPress():
		pass
	elif InputBuffer.consumePress(input.interact):
		tryInteract()
	else:
		return false
	return true

## Uses the item in the first pressed quick slot. Returns true if a quick slot button was pressed.
func consumeQuickSlotPress() -> bool:
	for slot in QUICK_SLOT_ORDER:
		if InputBuffer.consumePress(input.quickSlots[slot]):
			tryUseQuickSlot(slot)
			return true
	return false

func tryUseQuickSlot(slot : GlobalConstants.QuickSlotIndices) -> void:
	if not player.canQuickSlotItemBeUsed(slot):
		return

	var data := ItemDatabase.getItem(player.getQuickSlotItemID(slot))
	if data != null and not data.useState.is_empty():
		transition(data.useState)

func tryInteract() -> void:
	var object : WorldObject = player.interactableObject
	if object == null:
		return
	object.onInteract(player.playerIndex)
	if object.locksPlayerWhileInteracting:
		transition(STATEINTERACTING)

## Faces and aims the player in the held direction, if any. Used to allow changing
## direction between attacks.
func aimFromInput() -> void:
	var dir := input.moveVector()
	if dir:
		player.setPlayerDirection(dir)
		player.setAttackRotationFromDirection(dir)
