extends Area2D

var isPlayer1Inside = false
var isPlayer2Inside2 = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body = body as Player
		if body is Player1:
			EventHandler
			isPlayer1Inside = true
			EventHandler.player1Entered.emit()
		elif body is Player2:
			isPlayer2Inside2 = true
			EventHandler.player2Entered.emit()
	if isPlayer1Inside && isPlayer2Inside2:
		EventHandler.bothPlayersEntered.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body = body as Player
		if body is Player1:
			isPlayer1Inside = false
			EventHandler.player1Exited.emit()
		elif body is Player2:
			isPlayer2Inside2 = false
			EventHandler.player2Exited.emit()
	if !isPlayer1Inside && !isPlayer2Inside2:
		EventHandler.bothPlayersExited.emit()
