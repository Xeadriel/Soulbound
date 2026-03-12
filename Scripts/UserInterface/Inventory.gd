extends Control

@export var columns = 7
@export var rows = 3

#player number starts from 0
var selectedPlayerIndex = [0, 0]

var itemEnumsList = MenuGlobals.ItemIndices

var itemScenes = {
	itemEnumsList.POTION: preload("res://Scenes/Items/Potion.tscn")
}

func _ready() -> void:
	#just as a test
	addItemBuilder(itemEnumsList.POTION)
	addItemBuilder(itemEnumsList.POTION)
	
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
	

func moveSelector(dx: int, dy: int, playerNumber: int) -> void:
	var row = selectedPlayerIndex[playerNumber] / columns
	var col = selectedPlayerIndex[playerNumber] % columns
	col += dx
	row += dy
	row = clamp(row, 0, rows - 1)
	col = clamp(col, 0, columns - 1)
	selectedPlayerIndex[playerNumber] = row * columns + col
	updateSelector()

func updateSelector():
	var gc = $MarginContainer/VBoxContainer/InventoryBox/ItemList2/GridContainer
	for i in gc.get_child_count():
		var slot = gc.get_child(i)
		if selectedPlayerIndex[0] == i:
			slot.modulate = Color(0, 0, 1)
		elif selectedPlayerIndex[1] == i:
			slot.modulate = Color(1, 0, 0)
		elif selectedPlayerIndex[0] != i && selectedPlayerIndex[1] != i:
			slot.modulate = Color(0.3, 0.3, 0.3)

func addItemBuilder(itemEnum: int) -> void:
	if itemEnum in itemEnumsList.values():
		var itemName
		var itemScene
		match itemEnum:
			itemEnumsList.POTION:
				itemName = "Potion"
				itemScene = itemScenes[itemEnum]
				
			#add more items here
			
		addItem(itemName, itemScene)
	else:
		push_error("Invalid Item Enum value!")

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
