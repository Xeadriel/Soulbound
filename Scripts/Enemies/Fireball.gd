class_name Fireball extends EnemyProjectile

func _ready() -> void:
	rotation = direction.angle()
