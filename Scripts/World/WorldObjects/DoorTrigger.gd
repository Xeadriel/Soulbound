class_name DoorTrigger extends WorldObject

@onready var propertyCollidable = $PropertyCollidable
@export var open = false

func _ready() -> void:
	if open:
		print(animation)
		play("Opened")
		propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
		print(animation)
	else:
		play("Closed")
		propertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT

func onTriggered(state = true):
	if state:
		propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
		play("Open")
	else:
		propertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
		play("Close")
		
