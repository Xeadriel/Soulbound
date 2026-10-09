class_name Chest extends WorldObject

@export var containingItem : GlobalConstants.ItemIndices = GlobalConstants.ItemIndices.NOTHING
@export var amount = 0

func onInteract(_playerIndex: int) -> void:
	if not animation == "open":
		EventBus.itemReceived.emit(containingItem, amount)
		play("open")
