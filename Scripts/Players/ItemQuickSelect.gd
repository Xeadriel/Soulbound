class_name ItemQuickSelect extends Control
## Shows one player's four quick slots. The slot contents live in GlobalStates.session.

## Which player's quick slots this shows (0 or 1).
@export var playerIndex : int = 0

## Indexed by GlobalConstants.QuickSlotIndices (BOTTOM, TOP, LEFT, RIGHT).
@onready var quickSlots : Array[Item] = [$Control/BottomItem, $Control/TopItem, $Control/LeftItem, $Control/RightItem]

## How a quick slot item looks when it can't be used right now (e.g. all bottles empty).
const UNUSABLE_TINT := Color(1, 1, 1, 0.35)

func _ready() -> void:
	GlobalStates.session.quickSlotsChanged.connect(_onQuickSlotsChanged)
	GlobalStates.session.bottlesChanged.connect(refresh)
	refresh()

func _onQuickSlotsChanged(forPlayer: int) -> void:
	if forPlayer == playerIndex:
		refresh()

func refresh() -> void:
	for slot in quickSlots.size():
		var item := quickSlots[slot]
		item.id = GlobalStates.session.getQuickSlotItem(playerIndex, slot)
		if item.id == GlobalConstants.ItemIndices.BOTTLE:
			# the bottle shows how many full potions are left
			var potions := GlobalStates.session.bottlesWith(GlobalConstants.BottleContent.POTION)
			item.setItemAmount(potions)
			item.modulate = Color.WHITE if potions > 0 else UNUSABLE_TINT
		else:
			item.clearItemAmount()
			item.modulate = Color.WHITE
