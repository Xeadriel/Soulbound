class_name PropertyDetectingPlayer extends Area2D
## Reports players entering and leaving this area.

var isPlayer1Inside = false
var isPlayer2Inside = false

signal player1Entered
signal player2Entered
signal player1Exited
signal player2Exited

signal bothPlayersAreNowIn
signal bothPlayersAreNowOut

func _ready() -> void:
	PhysicsLayers.detectPlayerPresence(self)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.playerIndex == 0:
			isPlayer1Inside = true
			player1Entered.emit()
		else:
			isPlayer2Inside = true
			player2Entered.emit()
	if isPlayer1Inside && isPlayer2Inside:
		bothPlayersAreNowIn.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		if body.playerIndex == 0:
			isPlayer1Inside = false
			player1Exited.emit()
		else:
			isPlayer2Inside = false
			player2Exited.emit()
	if !isPlayer1Inside && !isPlayer2Inside:
		bothPlayersAreNowOut.emit()
