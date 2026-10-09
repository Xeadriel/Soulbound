class_name ItemQuickSelect extends Control
## Shows one player's four quick slots. The slot contents live in GlobalStates.session.

## Which player's quick slots this shows (0 or 1).
@export var playerIndex : int = 0

## Indexed by GlobalConstants.QuickSlotIndices (BOTTOM, TOP, LEFT, RIGHT).
@onready var quickSlots : Array[Item] = [$Control/BottomItem, $Control/TopItem, $Control/LeftItem, $Control/RightItem]

func _ready() -> void:
	GlobalStates.session.quickSlotsChanged.connect(_onQuickSlotsChanged)
	refresh()

func _onQuickSlotsChanged(forPlayer: int) -> void:
	if forPlayer == playerIndex:
		refresh()

func refresh() -> void:
	for slot in quickSlots.size():
		quickSlots[slot].id = GlobalStates.session.getQuickSlotItem(playerIndex, slot)
