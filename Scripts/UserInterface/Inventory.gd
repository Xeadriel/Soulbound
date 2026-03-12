extends Control

@export var columns = 7
@export var rows = 3

var playerSelectedIndex = [0, 0]

var itemEnumsList = MenuGlobals.ItemIndices

var itemScenes = {
	itemEnumsList.POTION: preload("res://Scenes/Items/Potion.tscn")
}

func _ready() -> void:
	#just as a test
	addItemDispatcher(itemEnumsList.POTION)
	addItemDispatcher(itemEnumsList.POTION)
	
	updateSelector()
	

func _process(delta: float) -> void:
	if self.has_focus():
		
		if EventHandler.isPlayerInputJustPressed("right") && !EventHandler.isPlayerInputPressed("hit"):
				moveSelector(1, 0, 0)
		elif EventHandler.isPlayerInputJustPressed("left") && !EventHandler.isPlayerInputPressed("hit"):
				moveSelector(-1, 0, 0)
		elif EventHandler.isPlayerInputJustPressed("up") && !EventHandler.isPlayerInputPressed("hit"):
				moveSelector(0, -1, 0)
		elif EventHandler.isPlayerInputJustPressed("down") && !EventHandler.isPlayerInputPressed("hit"):
				moveSelector(0, 1, 0)
		elif EventHandler.isPlayerInputJustPressed("left2") && !EventHandler.isPlayerInputPressed("hit2"):
				moveSelector(-1, 0, 1)
		elif EventHandler.isPlayerInputJustPressed("up2") && !EventHandler.isPlayerInputPressed("hit2"):
				moveSelector(0, -1, 1)
		elif EventHandler.isPlayerInputJustPressed("down2") && !EventHandler.isPlayerInputPressed("hit2"):
				moveSelector(0, 1, 1)
		elif EventHandler.isPlayerInputJustPressed("right2") && !EventHandler.isPlayerInputPressed("hit2"):
				moveSelector(1, 0, 1)
		elif EventHandler.isPlayerInputPressed("hit") && EventHandler.isPlayerInputPressed("right"):
			toQuickSlot(playerSelectedIndex[0], "right")
		elif EventHandler.isPlayerInputPressed("hit") && EventHandler.isPlayerInputPressed("left"):
			toQuickSlot(playerSelectedIndex[0], "left")
		elif EventHandler.isPlayerInputPressed("hit") && EventHandler.isPlayerInputPressed("up"):
			toQuickSlot(playerSelectedIndex[0], "up")
		elif EventHandler.isPlayerInputPressed("hit") && EventHandler.isPlayerInputPressed("down"):
			toQuickSlot(playerSelectedIndex[0], "down")
		elif EventHandler.isPlayerInputPressed("hit2") && EventHandler.isPlayerInputPressed("right2"):
			toQuickSlot(playerSelectedIndex[1], "right2")
		elif EventHandler.isPlayerInputPressed("hit2") && EventHandler.isPlayerInputPressed("left2"):
			toQuickSlot(playerSelectedIndex[1], "left2")
		elif EventHandler.isPlayerInputPressed("hit2") && EventHandler.isPlayerInputPressed("up2"):
			toQuickSlot(playerSelectedIndex[1], "up2")
		elif EventHandler.isPlayerInputPressed("hit2") && EventHandler.isPlayerInputPressed("down2"):
			toQuickSlot(playerSelectedIndex[1], "down2")

func toQuickSlot(itemIndex, quickslot):
	print("to quick Slot : " + str(itemIndex) + quickslot)

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
	var gc = $MarginContainer/VBoxContainer/InventoryBox/ItemList2/GridContainer
	for i in gc.get_child_count():
		var slot = gc.get_child(i)
		if playerSelectedIndex[0] == i:
			slot.modulate = Color(0, 0, 1)
		elif playerSelectedIndex[1] == i:
			slot.modulate = Color(1, 0, 0)
		elif playerSelectedIndex[0] != i && playerSelectedIndex[1] != i:
			slot.modulate = Color(0.3, 0.3, 0.3)

func addItemDispatcher(itemEnum: int) -> void:
	var itemName = null
	var itemScene = null
	match itemEnum:
		itemEnumsList.POTION:
			itemName = "Potion"
			itemScene = itemScenes[itemEnum]
			
		#
		#add more items here
		#
		
	if itemName != null && itemScene != null:
		addItem(itemName, itemScene)
	else:
		print("Invalid Item Enum value!")

func addItem(itemName: String, itemScene):
	var itemSlots = $MarginContainer/VBoxContainer/InventoryBox/ItemList2/GridContainer.get_children()
	var existedSlot = null;
	for i in itemSlots.size():
		if itemSlots[i].get_child_count() == 1 && itemSlots[i].get_children()[0].name == itemName:
			existedSlot = itemSlots[i]
			break
	if existedSlot != null:
		var countStr = existedSlot.get_children()[0].get_node("MarginContainer/ItemCount").text
		var countInt = 1 if int(countStr) == 0 else int(countStr)
		existedSlot.get_children()[0].get_node("MarginContainer/ItemCount").text = str(countInt+1)
	else:
		var freeSlot = null
		for i in itemSlots.size():
			if itemSlots[i].get_child_count() == 0:
				freeSlot = itemSlots[i]
				break
		if freeSlot != null:
			var newItem = itemScene.instantiate()
			freeSlot.add_child(newItem)
		else:
			print("Inventory is full!")
