extends Area2D

var isPlayer1Inside = false
var isPlayer2Inside2 = false

signal player1Entered
signal player2Entered
signal player1Exited
signal player2Exited

signal bothPlayersAreNowIn
signal bothPlayersAreNowOut

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body = body as Player
		if body is Player1:
			isPlayer1Inside = true
			player1Entered.emit()
		elif body is Player2:
			isPlayer2Inside2 = true
			player2Entered.emit()
	if isPlayer1Inside && isPlayer2Inside2:
		bothPlayersAreNowIn.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body = body as Player
		if body is Player1:
			isPlayer1Inside = false
			player1Exited.emit()
		elif body is Player2:
			isPlayer2Inside2 = false
			player2Exited.emit()
	if !isPlayer1Inside && !isPlayer2Inside2:
		bothPlayersAreNowOut.emit()
