class_name ItemQuickSelect extends Control

@onready var quickSlots = [$Control/BottomItem, $Control/TopItem, $Control/LeftItem, $Control/RightItem]

func _ready() -> void:
	pass

func switchItem(quickSlotIndex : GlobalConstants.QuickSlotIndices, item : Item):
	var quickSlot : Item = quickSlots[quickSlotIndex]
	quickSlot.id = item.id
	quickSlot.itemAmount = item.itemAmount
	quickSlot.setItemTexture(item.icon)

func getItem(quickSlotIndex : GlobalConstants.QuickSlotIndices) -> GlobalConstants.ItemIndices:
	var quickSlot : Item = quickSlots[quickSlotIndex]
	return quickSlot.id
