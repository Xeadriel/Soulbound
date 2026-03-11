class_name ItemQuickSelect extends Control

@onready var selectors = [$Control/BottomSelector, $Control/TopSelector, $Control/LeftSelector, $Control/RightSelector]

@export var items = []

func _ready() -> void:
	# load up the selectors with the list of items
	for selector : OptionButton in selectors:
		for texture in items:
			selector.add_icon_item(texture, "")

func switchItem(selectorIndex : MenuGlobals.SelectorIndices, itemIndex : MenuGlobals.ItemIndices):
	var selector : OptionButton = selectors[selectorIndex]
	selector.select(itemIndex)

func getItem(selectorIndex : MenuGlobals.SelectorIndices) -> MenuGlobals.ItemIndices:
	var selector : OptionButton = selectors[selectorIndex]
	return selector.get_selected_id()
