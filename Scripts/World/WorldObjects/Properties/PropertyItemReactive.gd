class_name PropertyItemReactive extends Area2D
## Lets the parent object react to being hit by certain items (whip, later bombs,
## hookshot, ...). Connect `triggered` to whatever should happen. The area's
## collision mask must include the layer of the item's hitbox.

## Emitted when one of the items in reactsTo hits this area.
signal triggered(playerIndex: int)

@export var reactsTo : Array[GlobalConstants.ItemIndices] = []

func onAreaEntered(area: Area2D) -> void:
	if area is ItemHitbox and area.item in reactsTo:
		area.queue_free()
		triggered.emit(area.playerIndex)
