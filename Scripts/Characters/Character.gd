class_name Character extends CharacterBody2D
## Shared base for everything that moves, faces a direction, has HP and runs a
## StateMachine: players, enemies and later NPCs.

signal damaged(amount: int)
signal died

@export var maxHp: int = 6

var hp: int:
	set(value):
		hp = value
		_onHpChanged()

var facing: Facing.Direction = Facing.Direction.DOWN

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stateMachine: StateMachine = $StateMachine

func _physics_process(_delta: float) -> void:
	move_and_slide()

## Plays "<base><Back|Front|Left|Right><extra>" for the current facing.
## Example: playDirectional("attack", "1") plays "attackFront1" when facing down.
## With a [param duration] above 0 the animation is sped up or slowed down to take
## that many seconds; otherwise it plays at its own speed.
func playDirectional(base: String, extra: String = "", duration: float = 0.0) -> void:
	var animationName := base + Facing.ANIM_SUFFIX[facing] + extra
	var speed := 1.0
	if duration > 0:
		speed = animationLength(animationName) / duration
	animatedSprite.play(animationName, speed)

## How long [param animationName] takes at normal speed, in seconds.
func animationLength(animationName: String) -> float:
	var frames := animatedSprite.sprite_frames
	var totalFrameDuration := 0.0
	for i in frames.get_frame_count(animationName):
		totalFrameDuration += frames.get_frame_duration(animationName, i)
	return totalFrameDuration / frames.get_animation_speed(animationName)

## Deals damage. [param source] is what caused it (attacker or projectile), if known.
func takeDamage(_amount: int, _source: Node2D = null) -> void:
	pass

## Called whenever hp changes. Override to react, e.g. to die.
func _onHpChanged() -> void:
	pass
