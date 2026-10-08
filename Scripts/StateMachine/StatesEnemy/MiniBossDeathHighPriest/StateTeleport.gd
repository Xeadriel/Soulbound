extends StateEnemyAnimated

func _init() -> void:
	animationPrefix = "teleport"
	speed = Speed.TELEGRAPH_TIME
	acquireTarget = false
	nextState = THINKING

func _onEnter(_data: Dictionary) -> void:
	entity.teleportAnimation()

func _onAnimationDone() -> void:
	if entity.animatedSprite.is_playing():
		return
	entity.teleport()
	transition(nextState)
