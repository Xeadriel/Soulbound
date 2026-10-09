extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "telegraph"
	speed = Speed.TELEGRAPH_TIME
	faceTarget = true
	nextState = ATK

func _onEnter(_data: Dictionary) -> void:
	entity.telegraphAttack()
