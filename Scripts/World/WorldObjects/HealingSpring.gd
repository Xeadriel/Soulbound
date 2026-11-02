class_name HealingSpring extends WorldObject
## Interact to fill all of the players' empty bottles. Never runs dry.

## What the spring fills bottles with. Other fluids (e.g. water) can reuse this object.
@export var content := GlobalConstants.BottleContent.POTION

func onInteract(_playerIndex: int) -> void:
	GlobalStates.session.fillEmptyBottles(content)
