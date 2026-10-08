class_name EnemyProjectile extends Projectile
## Projectile fired by enemies. Damages players.

func _isValidTarget(body: Node2D) -> bool:
	return body is Player
