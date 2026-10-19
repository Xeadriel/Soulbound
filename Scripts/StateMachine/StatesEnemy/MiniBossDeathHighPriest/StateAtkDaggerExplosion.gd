extends StateEnemyAnimated

func _init() -> void:
	animation = "daggerExplosion"
	keepTarget = true
	nextState = THINKING

func _onEnter(data: Dictionary) -> void:
	entity.daggerExplosionAtk(data["sacrificePos"])
