extends StateEnemy

var sacrificePos: Vector2

func process(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	sacrificePos = _data["sacrificePos"]
	entity.telegraphTime = 3.0
	#because the animations are set to 5 FPS speed scale can be used to decide the duration of the animation
	entity.animatedSprite.speed_scale = 1 / entity.telegraphTime # needs to be reset to 1 in exit
	entity.target = entity.getClosestPlayer()
	entity.facing = entity.getDirectionToPlayer()
	entity.velocity = Vector2.ZERO
	entity.telegraphDaggerExplosion()

func exit() -> void:
	entity.animatedSprite.speed_scale = 1

# if telegraph is done, switch to attack
func onAnimationFinished(animationName: String) -> void:
	if "telegraphDaggerExplosion" not in animationName:
		return
	transition(DAGGER_EXPLOSION, {"sacrificePos": sacrificePos})
