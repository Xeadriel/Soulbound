extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "daggerCircling"
	speed = Speed.SLOW
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.daggerCirclingAnimation()
	entity.daggerCirclingAtk()
