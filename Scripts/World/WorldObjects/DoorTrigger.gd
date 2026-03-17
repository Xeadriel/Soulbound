class_name DoorTrigger extends Node2D

@onready var propertyCollidable = $PropertyCollidable

func onTriggered():
	if propertyCollidable.process_mode == Node.PROCESS_MODE_INHERIT:
		propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
	elif propertyCollidable.process_mode == Node.PROCESS_MODE_INHERIT:
		propertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
