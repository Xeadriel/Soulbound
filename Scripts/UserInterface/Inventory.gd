extends Control

@export var columns = 7
@export var rows = 3

var playerSelectedIndex = [0, 0]

@onready var gridContainer = $MarginContainer/VBoxContainer/InventoryBox/ItemList2/GridContainer

signal insertQuickSlot(
	itemEnum: GlobalConstants.ItemIndices, 
	quickslot: GlobalConstants.QuickSlotIndices
	)

signal insertQuickSlot2(
	itemEnum: GlobalConstants.ItemIndices, 
	quickslot: GlobalConstants.QuickSlotIndices
	)

func _ready() -> void:
	
	#just as a test
	addItem(GlobalConstants.ItemIndices.POTION, 5)
	
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
			toQuickSlot(playerSelectedIndex[0], GlobalConstants.QuickSlotIndices.RIGHT, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotLeft"):
			toQuickSlot(playerSelectedIndex[0], GlobalConstants.QuickSlotIndices.LEFT, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotTop"):
			toQuickSlot(playerSelectedIndex[0], GlobalConstants.QuickSlotIndices.TOP, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotBottom"):
			toQuickSlot(playerSelectedIndex[0], GlobalConstants.QuickSlotIndices.BOTTOM, 1)
		elif EventHandler.isPlayerInputPressed("quickSlotRight2"):
			toQuickSlot(playerSelectedIndex[1], GlobalConstants.QuickSlotIndices.RIGHT, 2)
		elif EventHandler.isPlayerInputPressed("quickSlotLeft2"):
			toQuickSlot(playerSelectedIndex[1], GlobalConstants.QuickSlotIndices.LEFT, 2)
		elif EventHandler.isPlayerInputPressed("quickSlotTop2"):
			toQuickSlot(playerSelectedIndex[1], GlobalConstants.QuickSlotIndices.TOP, 2)
		elif EventHandler.isPlayerInputPressed("quickSlotBottom2"):
			toQuickSlot(playerSelectedIndex[1], GlobalConstants.QuickSlotIndices.BOTTOM, 2)

func toQuickSlot(itemIndex: int, quickslot: GlobalConstants.QuickSlotIndices, playerNumber: int):
	var itemSlot: Item = gridContainer.get_child(itemIndex).get_child(0)
	if itemSlot != null && itemSlot.visible:
		match playerNumber:
			1: 
				insertQuickSlot.emit(itemSlot, quickslot)
			2: 
				insertQuickSlot.emit(itemSlot, quickslot)
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

func addItem(itemEnum: GlobalConstants.ItemIndices, amount: int):
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
