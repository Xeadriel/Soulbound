class_name StateEnemyAnimated extends StateEnemy
## Base for enemy states that play one directional animation and switch to
## `nextState` when it finishes, like telegraphs and attacks.
## Subclasses set `animation`, `faceTarget` and `keepTarget` in _init() and add their
## own behavior in _onEnter(), _onExit() and _onAnimationDone(). How long the
## animation takes is set per scene with `duration`.

## State to switch to when the animation finishes.
@export var nextState: String = ""
## How long the animation takes, in seconds. 0 plays it at its own speed.
@export var duration := 0.0

## Animation name without the direction suffix, e.g. "telegraphSwipe".
var animation: String = ""
## Turn towards the target when entering. Telegraphs do this so the attack
## goes where the telegraph pointed.
var faceTarget := false
## Keep the current target instead of picking the closest player. Attacks do this
## so they hit the player their telegraph aimed at.
var keepTarget := false

func enter(_previous_state_path: String, data := {}) -> void:
	if not keepTarget:
		entity.target = entity.getClosestPlayer()
	if faceTarget:
		entity.facing = entity.getDirectionToPlayer()
	entity.velocity = Vector2.ZERO
	entity.playDirectional(animation, "", duration)
	_onEnter(data)

func exit() -> void:
	_onExit()

func onAnimationFinished(animationName: String) -> void:
	if animationName.begins_with(animation):
		_onAnimationDone()

## The state's own behavior on entering. The animation is already playing.
func _onEnter(_data: Dictionary) -> void:
	pass

func _onExit() -> void:
	pass

func _onAnimationDone() -> void:
	transition(nextState)
