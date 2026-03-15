class_name ItemQuickSelect extends Control

@onready var quickSlots = [$Control/BottomItem, $Control/TopItem, $Control/LeftItem, $Control/RightItem]

func _ready() -> void:
	assert(
		self.name == "ItemQuickSelect" || self.name == "ItemQuickSelect2", 
		"Quick Select Node Name Incorrect!"
	)
	EventHandler.itemAssignedToQuickSlot.connect(_on_item_inserted)
	EventHandler.itemAssignedToQuickSlot2.connect(_on_item_inserted2)

func _on_item_inserted(item: Item, quickslot: GlobalConstants.QuickSlotIndices):
	if self.name == "ItemQuickSelect":
		switchItem(quickslot, item)

func _on_item_inserted2(item: Item, quickslot: GlobalConstants.QuickSlotIndices):
	if self.name == "ItemQuickSelect2":
		switchItem(quickslot, item)

func switchItem(quickSlotIndex : GlobalConstants.QuickSlotIndices, item : Item):
	var existedSlot: Item = null
	var quickSlot : Item = quickSlots[quickSlotIndex]
	for s: Item in quickSlots:
		if s.id == item.id:
			existedSlot = s
			break
	if existedSlot != null:
		existedSlot.id = quickSlot.id
		existedSlot.itemAmount = quickSlot.itemAmount
		existedSlot.setItemTexture(quickSlot.texture)
		
	quickSlot.id = item.id
	quickSlot.itemAmount = item.itemAmount
	quickSlot.setItemTexture(item.texture)

func getItem(quickSlotIndex : GlobalConstants.QuickSlotIndices) -> GlobalConstants.ItemIndices:
	var quickSlot : Item = quickSlots[quickSlotIndex]
	return quickSlot.id
