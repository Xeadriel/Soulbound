class_name Door extends DoorBase
## Door the players open and close by interacting. Locked doors need a key item,
## which is used up the first time the door is unlocked.

var isOpen = false
var unlocked = false

@export var key: GlobalConstants.ItemIndices

func _ready() -> void:
	if key == GlobalConstants.ItemIndices.NOTHING:
		unlocked = true
	super._ready()
	setOpen(isOpen)

func onInteract(_playerIndex: int) -> void:
	if !unlocked && GlobalStates.session.removeItem(key):
		unlocked = true

	if unlocked:
		isOpen = not isOpen
		setOpen(isOpen)
