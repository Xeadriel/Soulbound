extends Node

# Global script for in game states. `session` holds everything that is needed to
# create a save file, like game progress, and is null while no game is running.

## Gives both players the whip in their bottom quick slot and some items at the
## start, for testing.
const DEBUG_START_ITEMS := true

var session: GameSession = null
var projectileNode: Node

func _ready() -> void:
	EventBus.itemReceived.connect(onItemReceived)
	# TODO: call this from the main menu once it exists
	startNewGame()

func startNewGame() -> void:
	session = GameSession.new()
	if DEBUG_START_ITEMS:
		session.setItemCount(GlobalConstants.ItemIndices.POTION, 5)
		session.setItemCount(GlobalConstants.ItemIndices.WHIP, 1)
		for playerIndex in GameSession.PLAYER_COUNT:
			session.assignQuickSlot(playerIndex, GlobalConstants.QuickSlotIndices.BOTTOM, GlobalConstants.ItemIndices.WHIP)

func endSession() -> void:
	session = null

func onItemReceived(item : GlobalConstants.ItemIndices, amount : int) -> void:
	if session != null:
		session.addItem(item, amount)
