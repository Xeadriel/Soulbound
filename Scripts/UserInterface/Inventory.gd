extends Control

@export var columns = 7
@export var rows = 3

var playerSelectedIndex = [0, 0]

@onready var gridContainer = $MarginContainer/VBoxContainer/InventoryBox/ItemList2/GridContainer

## Input profiles of both players, indexed by player index.
var playerInputs : Array[PlayerInputProfile] = [PlayerInputProfile.forPlayer(0), PlayerInputProfile.forPlayer(1)]

## Quick slot buttons in the order they are checked.
const QUICK_SLOT_CHECK_ORDER : Array[GlobalConstants.QuickSlotIndices] = [
	GlobalConstants.QuickSlotIndices.RIGHT,
	GlobalConstants.QuickSlotIndices.LEFT,
	GlobalConstants.QuickSlotIndices.TOP,
	GlobalConstants.QuickSlotIndices.BOTTOM,
]

func _ready() -> void:
	updateSelector()

func _process(_delta: float) -> void:
	if not has_focus():
		return
	# only one action per frame: first both players' cursor movement, then quick slot assignment
	for playerIndex in playerInputs.size():
		if handleCursorInput(playerIndex):
			return
	for playerIndex in playerInputs.size():
		if handleQuickSlotInput(playerIndex):
			return

func handleCursorInput(playerIndex: int) -> bool:
	var input := playerInputs[playerIndex]
	if InputBuffer.consumePress(input.right):
		moveSelector(1, 0, playerIndex)
	elif InputBuffer.consumePress(input.left):
		moveSelector(-1, 0, playerIndex)
	elif InputBuffer.consumePress(input.up):
		moveSelector(0, -1, playerIndex)
	elif InputBuffer.consumePress(input.down):
		moveSelector(0, 1, playerIndex)
	else:
		return false
	return true

func handleQuickSlotInput(playerIndex: int) -> bool:
	var input := playerInputs[playerIndex]
	for slot in QUICK_SLOT_CHECK_ORDER:
		if InputBuffer.isHeld(input.quickSlots[slot]):
			toQuickSlot(playerSelectedIndex[playerIndex], slot, playerIndex)
			return true
	return false

func toQuickSlot(itemIndex: int, quickslot: GlobalConstants.QuickSlotIndices, playerIndex: int):
	var itemSlot: Item = getItemInSlot(gridContainer.get_child(itemIndex))
	if itemSlot != null && itemSlot.visible:
		GlobalStates.session.assignQuickSlot(playerIndex, quickslot, itemSlot.id)
	else:
		print("itemSlot is empty: " + str(itemIndex))

func moveSelector(dx: int, dy: int, playerNumber: int) -> void:
	var row = playerSelectedIndex[playerNumber] / columns
	var col = playerSelectedIndex[playerNumber] % columns
	col += dx
	row += dy
	row = clamp(row, 0, rows - 1)
	col = clamp(col, 0, columns - 1)
	playerSelectedIndex[playerNumber] = row * columns + col
	updateSelector()

func updateSelector():
	for i in gridContainer.get_child_count():
		var slot = gridContainer.get_child(i)
		if playerSelectedIndex[0] == i:
			slot.modulate = Color(0, 0, 1)
		elif playerSelectedIndex[1] == i:
			slot.modulate = Color(1, 0, 0)
		elif playerSelectedIndex[0] != i && playerSelectedIndex[1] != i:
			slot.modulate = Color(0.3, 0.3, 0.3)

func updateDescriptionBox():
	var p1Text = gridContainer[playerSelectedIndex[0]].get_child(0).Description
	var p2Text = gridContainer[playerSelectedIndex[1]].get_child(0).Description

func updateInventoryState():
	var inventory := GlobalStates.session.inventory
	for key in inventory:
		var itemSlots = gridContainer.get_children()
		for i in itemSlots.size():
			var item: Item = getItemInSlot(itemSlots[i])
			if item != null && item.id == key:
				item.visible = true
				item.setItemAmount(inventory[key])

## The Item shown in an inventory slot, or null if the slot is empty.
func getItemInSlot(slot: Node) -> Item:
	return slot.get_child(0) if slot.get_child_count() > 0 else null
