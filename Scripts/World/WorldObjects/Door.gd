extends Node2D

var isOpen = false

func _ready() -> void:
	$PropertyInteractable.interacted.connect(interactDoor)

func _process(delta: float) -> void:
	pass

func interactDoor():
	if isOpen:
		isOpen = false
		$PropertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
		$TextureRect.visible = true
	else:
		isOpen = true
		$PropertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
		$TextureRect.visible = false
