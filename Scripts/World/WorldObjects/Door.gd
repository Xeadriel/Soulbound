extends Node2D

var isOpen = false
var unlocked = false

@export var key: GlobalConstants.ItemIndices

func _ready() -> void:
	if key == GlobalConstants.ItemIndices.NOTHING:
		unlocked = true

func _process(delta: float) -> void:
	pass

func _on_property_interactable_interacted() -> void:
	var keyAvailable = false
	if !unlocked && GlobalStates.inventory.get(key, 0) > 0:
		keyAvailable = true
		unlocked = true
		GlobalStates.inventory[key] -= 1

	if unlocked || keyAvailable || key == GlobalConstants.ItemIndices.NOTHING:
		if isOpen:
			isOpen = false
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_INHERIT
			$TextureRect.visible = true
		else:
			isOpen = true
			$PropertyCollidable.process_mode = Node.PROCESS_MODE_DISABLED
			$TextureRect.visible = false
