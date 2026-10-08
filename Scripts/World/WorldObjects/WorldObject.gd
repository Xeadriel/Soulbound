class_name WorldObject extends AnimatedSprite2D
## Base for objects placed in the world. Behaviors such as being interactable,
## collidable or whippable are added as Property* child nodes.

## If true, interacting with this object puts the player into StateInteracting
## until they interact again (e.g. puzzle terminals).
@export var locksPlayerWhileInteracting := false

## Called when a player interacts with this object. playerIndex is 0 or 1.
func onInteract(_playerIndex: int) -> void:
	pass

func appear():
	visible = true
	# add some particles here
	process_mode = Node.PROCESS_MODE_INHERIT
