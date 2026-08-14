class_name DoorTrigger extends WorldObject

@onready var propertyCollidable = $PropertyCollidable
@export var open = false

var CLOSE = "Close"
var OPEN = "Open"

@export var isHorizontal = true

func _ready() -> void:
	var propertyCollidable : PropertyCollidable = $PropertyCollidable
	
	if not isHorizontal:
		propertyCollidable.rotation_degrees = 90
		CLOSE = "VerticalClose"
		OPEN = "VerticalOpen"
		
		if open:
			play("VerticalOpened")
			propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			play("VerticalClosed")
			propertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
		
		return
		
	if open:
		play("Opened")
		propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		play("Closed")
		propertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT

func onTriggered(state = true):
	if state:
		propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
		play(OPEN)
	else:
		propertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
		play(CLOSE)
		
