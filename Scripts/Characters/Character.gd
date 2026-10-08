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
func playDirectional(base: String, extra: String = "") -> void:
	animatedSprite.play(base + Facing.ANIM_SUFFIX[facing] + extra)

## Deals damage. [param source] is what caused it (attacker or projectile), if known.
func takeDamage(_amount: int, _source: Node2D = null) -> void:
	pass

## Called whenever hp changes. Override to react, e.g. to die.
func _onHpChanged() -> void:
	pass
