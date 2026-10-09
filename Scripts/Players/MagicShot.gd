class_name MagicShot extends Projectile
## Player 2's magic shot. Damages enemies and passes through its own player.

var player : Player = null

func _isValidTarget(body: Node2D) -> bool:
	return body is Enemy

func _ignores(node: Node) -> bool:
	return node == player

## Charged shots wait (frozen) at their spawn point until released.
func waitForRelease() -> void:
	process_mode = PROCESS_MODE_DISABLED

func release() -> void:
	process_mode = PROCESS_MODE_INHERIT
