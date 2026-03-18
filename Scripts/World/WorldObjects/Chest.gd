class_name Chest extends WorldObject

@export var containingItem : GlobalConstants.ItemIndices = GlobalConstants.ItemIndices.NOTHING
@export var amount = 0

func interacted():
	if not animation == "open":
		EventHandler.itemReceived.emit(containingItem, amount)
		play(&"open")
