extends Node2D

var isOpen = false

@export var key: GlobalConstants.ItemIndices

			
func _ready() -> void:
	$PropertyInteractable.interacted.connect(interactDoor)

func _process(delta: float) -> void:
	pass

func interactDoor():
	var keyAvailable = false
	if GlobalStates.inventory.get(key, 0) > 0:
		keyAvailable = true

	if keyAvailable || key == GlobalConstants.ItemIndices.NOTHING:
		if isOpen:
			isOpen = false
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
			$TextureRect.visible = true
		else:
			isOpen = true
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
			$TextureRect.visible = false
