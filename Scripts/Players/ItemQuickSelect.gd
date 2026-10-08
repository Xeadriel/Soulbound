class_name ItemQuickSelect extends Control

## Which player's quick slots this shows (0 or 1).
@export var playerIndex : int = 0

@onready var quickSlots = [$Control/BottomItem, $Control/TopItem, $Control/LeftItem, $Control/RightItem]

func _ready() -> void:
	EventBus.quickSlotAssigned.connect(_onQuickSlotAssigned)

func _onQuickSlotAssigned(forPlayer: int, item: Item, quickslot: GlobalConstants.QuickSlotIndices) -> void:
	if forPlayer == playerIndex:
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
