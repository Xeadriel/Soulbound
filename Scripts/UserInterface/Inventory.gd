extends Control

@export var columns = 7
@export var rows = 3

var playerSelectedIndex = [0, 0]

@onready var gridContainer = $MarginContainer/VBoxContainer/InventoryBox/ItemList2/GridContainer

signal insertQuickSlot(
	itemEnum: MenuGlobals.ItemIndices, 
	quickslot: MenuGlobals.SelectorIndices
	)

signal insertQuickSlot2(
	itemEnum: MenuGlobals.ItemIndices, 
	quickslot: MenuGlobals.SelectorIndices
	)

func _ready() -> void:
	
	#just as a test
	addItem(MenuGlobals.ItemIndices.POTION, 5)
	
	updateSelector()
	

func _process(delta: float) -> void:
	if self.has_focus():
		
		if EventHandler.isPlayerInputJustPressed("right"):
				moveSelector(1, 0, 0)
		elif EventHandler.isPlayerInputJustPressed("left"):
				moveSelector(-1, 0, 0)
		elif EventHandler.isPlayerInputJustPressed("up"):
				moveSelector(0, -1, 0)
		elif EventHandler.isPlayerInputJustPressed("down"):
				moveSelector(0, 1, 0)
		elif EventHandler.isPlayerInputJustPressed("left2"):
				moveSelector(-1, 0, 1)
		elif EventHandler.isPlayerInputJustPressed("up2"):
				moveSelector(0, -1, 1)
		elif EventHandler.isPlayerInputJustPressed("down2"):
				moveSelector(0, 1, 1)
		elif EventHandler.isPlayerInputJustPressed("right2"):
				moveSelector(1, 0, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotRight"):
			toQuickSlot(playerSelectedIndex[0], MenuGlobals.SelectorIndices.RIGHT, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotLeft"):
			toQuickSlot(playerSelectedIndex[0], MenuGlobals.SelectorIndices.LEFT, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotTop"):
			toQuickSlot(playerSelectedIndex[0], MenuGlobals.SelectorIndices.TOP, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotBottom"):
			toQuickSlot(playerSelectedIndex[0], MenuGlobals.SelectorIndices.BOTTOM, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotRight2"):
			toQuickSlot(playerSelectedIndex[1], MenuGlobals.SelectorIndices.RIGHT, 2)
		elif EventHandler.isPlayerInputPressed("quickSlotLeft2"):
			toQuickSlot(playerSelectedIndex[1], MenuGlobals.SelectorIndices.LEFT, 2)
		elif EventHandler.isPlayerInputPressed("quickSlotTop2"):
			toQuickSlot(playerSelectedIndex[1], MenuGlobals.SelectorIndices.TOP, 2)
		elif EventHandler.isPlayerInputPressed("quickSlotBottom2"):
			toQuickSlot(playerSelectedIndex[1], MenuGlobals.SelectorIndices.BOTTOM, 2)

func toQuickSlot(itemIndex: int, quickslot: MenuGlobals.SelectorIndices, playerNumber: int):
	var itemSlot: Item = gridContainer.get_child(itemIndex).get_child(0)
	if itemSlot != null && itemSlot.visible:
		match playerNumber:
			1: 
				emit_signal("insertQuickSlot", itemSlot, quickslot)
			2: 
				emit_signal("insertQuickSlot2", itemSlot, quickslot)
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

func addItem(itemEnum: MenuGlobals.ItemIndices, amount: int):
	var itemSlots = gridContainer.get_children()
	var targetSlot: Item = null;
	for i in itemSlots.size():
		var slot: Item = itemSlots[i].get_child(0)
		if slot.id == itemEnum:
			targetSlot = slot
			break
	if !targetSlot.visible:
		targetSlot.visible = true
	targetSlot.addItemAmount(amount)
