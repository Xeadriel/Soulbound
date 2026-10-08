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
	
	if isOpen:
		play(OPEN)
		$PropertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		play(CLOSE)
		$PropertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
	
	set_process(false)
	set_physics_process(false)


func onInteract(_playerIndex: int) -> void:
	var keyAvailable = false
	if !unlocked && GlobalStates.session.removeItem(key):
		keyAvailable = true
		unlocked = true

	if unlocked || keyAvailable || key == GlobalConstants.ItemIndices.NOTHING:
		if isOpen:
			isOpen = false
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
			play(CLOSE)
		else:
			isOpen = true
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
			play(OPEN)
