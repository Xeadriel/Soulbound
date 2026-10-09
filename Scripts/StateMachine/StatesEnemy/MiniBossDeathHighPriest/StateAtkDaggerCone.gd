extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "daggerCone"
	speed = Speed.SLOW
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.daggerConeAnimation()
	entity.daggerConeAtk()
