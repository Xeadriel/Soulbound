class_name Door extends WorldObject

var isOpen = false
var unlocked = false

var CLOSE = "Close"
var OPEN = "Open"

@export var isHorizontal = true
@export var key: GlobalConstants.ItemIndices

func _ready() -> void:
	if key == GlobalConstants.ItemIndices.NOTHING:
		unlocked = true
	var propertyCollidable : PropertyCollidable = $PropertyCollidable
	
	if not isHorizontal:
		propertyCollidable.rotation_degrees = 90
		CLOSE = "VerticalClose"
		OPEN = "VerticalOpen"
		
	play(CLOSE)

func _process(delta: float) -> void:
	pass

func onInteract(_playerNumber) -> void:
	var keyAvailable = false
	if !unlocked && GlobalStates.inventory.get(key, 0) > 0:
		keyAvailable = true
		unlocked = true
		GlobalStates.inventory[key] -= 1

	if unlocked || keyAvailable || key == GlobalConstants.ItemIndices.NOTHING:
		if isOpen:
			isOpen = false
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
			play(CLOSE)
		else:
			isOpen = true
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
			play(OPEN)
