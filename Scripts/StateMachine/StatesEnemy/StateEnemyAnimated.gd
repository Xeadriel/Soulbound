class_name StateEnemyAnimated extends StateEnemy
## Base for enemy states that play one directional animation and switch to
## `nextState` when it finishes, like telegraphs and attacks.
## Enemy animations run at 5 FPS, so speed_scale decides how long they take.
## Subclasses configure the variables below in _init() and add their own
## behavior in _onEnter(), _onExit() and _onAnimationDone().

enum Speed {
	## Play at normal speed.
	NORMAL,
	## Take entity.telegraphTime seconds.
	TELEGRAPH_TIME,
	## Play at SLOW_SPEED_SCALE.
	SLOW,
}

const SLOW_SPEED_SCALE := 0.1

## State to switch to when the animation finishes.
@export var nextState: String = ""

## Animation name without the direction suffix, e.g. "telegraphSwipe".
var animationPrefix: String = ""
var speed: Speed = Speed.NORMAL
## If greater than 0, entity.telegraphTime is set to this when entering.
var telegraphTimeOverride: float = 0.0
var acquireTarget := true
var faceTarget := false
var stopMoving := true

func enter(_previous_state_path: String, data := {}) -> void:
	if telegraphTimeOverride > 0:
		entity.telegraphTime = telegraphTimeOverride
	match speed:
		Speed.TELEGRAPH_TIME:
			entity.animatedSprite.speed_scale = 1 / entity.telegraphTime
		Speed.SLOW:
			entity.animatedSprite.speed_scale = SLOW_SPEED_SCALE
	if acquireTarget:
		entity.target = entity.getClosestPlayer()
	if faceTarget:
		entity.facing = entity.getDirectionToPlayer()
	if stopMoving:
		entity.velocity = Vector2.ZERO
	_onEnter(data)

func exit() -> void:
	entity.animatedSprite.speed_scale = 1
	_onExit()

func onAnimationFinished(animationName: String) -> void:
	if animationName.begins_with(animationPrefix):
		_onAnimationDone()

## Start the animation and the state's own behavior here.
func _onEnter(_data: Dictionary) -> void:
	pass

func _onExit() -> void:
	pass

func _onAnimationDone() -> void:
	transition(nextState)
