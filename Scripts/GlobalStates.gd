extends Node

# Global script for in game states. `session` holds everything that is needed to
# create a save file, like game progress, and is null while no game is running.

## Gives both players the whip in their bottom quick slot and some items at the
## start, for testing.
const DEBUG_START_ITEMS := false
## Where the starting bottle goes for both players.
const BOTTLE_QUICK_SLOT := GlobalConstants.QuickSlotIndices.TOP

var session: GameSession = null
var projectileNode: Node

func _ready() -> void:
	EventBus.itemReceived.connect(onItemReceived)
	# TODO: call this from the main menu once it exists
	startNewGame()

func startNewGame() -> void:
	session = GameSession.new()
	# the players start with one bottle of potion, ready to drink
	session.addBottle(GlobalConstants.BottleContent.POTION)
	for playerIndex in GameSession.PLAYER_COUNT:
		session.assignQuickSlot(playerIndex, BOTTLE_QUICK_SLOT, GlobalConstants.ItemIndices.BOTTLE)
	if DEBUG_START_ITEMS:
		session.addBottle(GlobalConstants.BottleContent.POTION)
		session.setItemCount(GlobalConstants.ItemIndices.WHIP, 1)
		for playerIndex in GameSession.PLAYER_COUNT:
			session.assignQuickSlot(playerIndex, GlobalConstants.QuickSlotIndices.BOTTOM, GlobalConstants.ItemIndices.WHIP)

func endSession() -> void:
	session = null

func onItemReceived(item : GlobalConstants.ItemIndices, amount : int) -> void:
	if session == null:
		return
	if item == GlobalConstants.ItemIndices.BOTTLE:
		# bottles also need an entry for what they hold
		for i in amount:
			session.addBottle()
	else:
		session.addItem(item, amount)
