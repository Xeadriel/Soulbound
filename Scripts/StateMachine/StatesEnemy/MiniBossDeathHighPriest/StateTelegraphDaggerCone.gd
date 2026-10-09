extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "telegraphDaggerCone"
	speed = Speed.TELEGRAPH_TIME
	telegraphTimeOverride = 3.0
	faceTarget = true
	nextState = DAGGER_CONE

func _onEnter(_data: Dictionary) -> void:
	entity.telegraphDaggerCone()
