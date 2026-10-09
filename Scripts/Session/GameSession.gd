class_name GameSession extends Resource
## Everything that belongs in a save file: inventory, quick slots, map progress.
## GlobalStates.session holds the running game's session (null when no game runs).

signal inventoryChanged(item: GlobalConstants.ItemIndices, count: int)
signal quickSlotsChanged(playerIndex: int)

const PLAYER_COUNT := 2
const QUICK_SLOT_COUNT := 4

@export var inventory : Dictionary[GlobalConstants.ItemIndices, int] = {}
## quickSlots[playerIndex][GlobalConstants.QuickSlotIndices] = item id
@export var quickSlots : Array[Array] = []
## Names of the rooms the players have been in (used as a set).
@export var seenRooms : Dictionary[String, bool] = {}
## Name of the room a player entered last, empty before the first room.
@export var currentRoom : String = ""
@export var currentDungeon : String

func _init() -> void:
	for item in GlobalConstants.ItemIndices.values():
		inventory[item] = 0
	for playerIndex in PLAYER_COUNT:
		var slots := []
		slots.resize(QUICK_SLOT_COUNT)
		slots.fill(GlobalConstants.ItemIndices.NOTHING)
		quickSlots.append(slots)

# --- inventory ---

func getItemCount(item : GlobalConstants.ItemIndices) -> int:
	return inventory.get(item, 0)

func setItemCount(item : GlobalConstants.ItemIndices, count : int) -> void:
	inventory[item] = count
	inventoryChanged.emit(item, count)

func addItem(item : GlobalConstants.ItemIndices, amount : int = 1) -> void:
	setItemCount(item, getItemCount(item) + amount)

## Takes [param amount] of the item out of the inventory. Returns false (and takes
## nothing) if there are not enough.
func removeItem(item : GlobalConstants.ItemIndices, amount : int = 1) -> bool:
	if getItemCount(item) < amount:
		return false
	setItemCount(item, getItemCount(item) - amount)
	return true

# --- quick slots ---

func getQuickSlotItem(playerIndex : int, slot : GlobalConstants.QuickSlotIndices) -> GlobalConstants.ItemIndices:
	return quickSlots[playerIndex][slot]

## Puts an item into a quick slot. If the item already sits in another of the
## player's slots, the two slots swap. Returns false for items that cannot be equipped.
func assignQuickSlot(playerIndex : int, slot : GlobalConstants.QuickSlotIndices, item : GlobalConstants.ItemIndices) -> bool:
	var data := ItemDatabase.getItem(item)
	if data == null or not data.equippable:
		return false
	var slots : Array = quickSlots[playerIndex]
	var previousSlot := slots.find(item)
	if previousSlot != -1:
		slots[previousSlot] = slots[slot]
	slots[slot] = item
	quickSlotsChanged.emit(playerIndex)
	return true

# --- map ---

func markRoomVisited(roomName : String) -> void:
	currentRoom = roomName
	seenRooms[roomName] = true
