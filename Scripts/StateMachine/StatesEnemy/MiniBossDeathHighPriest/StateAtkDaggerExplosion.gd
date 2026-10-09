extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "daggerExplosion"
	speed = Speed.SLOW
	nextState = THINKING

func _onEnter(data: Dictionary) -> void:
	entity.daggerExplosion()
	entity.daggerExplosionAtk(data["sacrificePos"])
