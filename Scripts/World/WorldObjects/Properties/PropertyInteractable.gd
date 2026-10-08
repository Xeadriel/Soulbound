class_name PropertyInteractable extends Area2D
## Makes the parent WorldObject interactable while a player is inside this area.

## Indexed by Player.playerIndex.
var playersCloseEnough : Array[bool] = [false, false]

func _ready() -> void:
	PhysicsLayers.detectPlayerPresence(self)

func onBodyEntered(body: Node2D) -> void:
	if body is Player:
		body.setInteractable(get_parent())
		playersCloseEnough[body.playerIndex] = true

func onBodyExited(body: Node2D) -> void:
	if body is Player:
		# only clear it if the player has not moved into another object's range meanwhile
		if body.interactableObject == get_parent():
			body.setInteractable(null)
		playersCloseEnough[body.playerIndex] = false
