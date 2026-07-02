class_name StateEnemy extends State

const IDLE = "StateIdle"
const RUN = "StateRun"
const ATK = "StateAtk"
const RUNCIRCLE = "StateRunCircle"
const TELEGRAPH = "StateTelegraph"
const STUNNED = "StateStunned"
const TAUNT = "StateTaunt"

const STRAFE = "StateStrafe"
const SWIPE = "StateAtkSwipe"
const TELEGRAPH_SWIPE = "StateTelegraphSwipe"
const THINKING = "StateThinking"
const SACRIFICE = "StateSacrifice"
const DAGGER_CONE = "StateDaggerCone"
const TELEGRAPH_DAGGER_CONE = "StateTelegraphDaggerCone"
const DAGGER_EXPLOSION = "StateDaggerExplosion"
const TELEGRAPH_DAGGER_EXPLOSION = "StateTelegraphDaggerExplosion"
const DAGGER_CIRCLING = "StateDaggerCircling"
const TELEGRAPH_DAGGER_CIRCLING = "StateTelegraphDaggerCircling"
const TELEPORT = "StateTeleport"
const CAST_SHIELD = "StateCastShield"

@export var entity: Enemy = null

enum inRangeBehavior {ATK, CIRCLE}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(entity != null, "Entity should not be null")
	assert(owner is Enemy, "StateEnemy Class belongs only to Enemy class!")
