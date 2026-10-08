extends StateEnemyAnimated

## Where the sacrificed goblin stood. The daggers explode from there.
var sacrificePos: Vector2

func _init() -> void:
	animationPrefix = "telegraphDaggerExplosion"
	speed = Speed.TELEGRAPH_TIME
	telegraphTimeOverride = 3.0
	faceTarget = true
	nextState = DAGGER_EXPLOSION

func _onEnter(data: Dictionary) -> void:
	sacrificePos = data["sacrificePos"]
	entity.telegraphDaggerExplosion()

func _onAnimationDone() -> void:
	transition(nextState, {"sacrificePos": sacrificePos})
