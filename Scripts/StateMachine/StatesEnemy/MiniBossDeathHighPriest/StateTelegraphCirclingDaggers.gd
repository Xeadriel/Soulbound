extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "telegraphDaggerCircling"
	speed = Speed.TELEGRAPH_TIME
	telegraphTimeOverride = 3.0
	faceTarget = true
	nextState = DAGGER_CIRCLING

func _onEnter(_data: Dictionary) -> void:
	entity.telegraphDaggerCircling()
	entity.spawnDaggerCircle()
