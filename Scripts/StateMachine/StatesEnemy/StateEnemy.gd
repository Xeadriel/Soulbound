class_name StateEnemy extends State
## Base class for enemy states. Gives access to the enemy and shared helpers.

const IDLE = "StateIdle"
const RUN = "StateRun"
const ATK = "StateAtk"
const RUNCIRCLE = "StateRunCircle"
const TELEGRAPH = "StateTelegraph"
const STUNNED = "StateStunned"
const TAUNT = "StateTaunt"

const STRAFE = "StateStrafe"
const SWIPE = "StateSwipe"
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

func _ready() -> void:
	if entity == null:
		entity = owner as Enemy
	assert(entity != null, "Entity should not be null")
	assert(owner is Enemy, "StateEnemy Class belongs only to Enemy class!")

## Targets the closest player and returns the distance to it.
func targetClosestPlayer() -> float:
	entity.target = entity.getClosestPlayer()
	return entity.global_position.distance_to(entity.target.global_position)

## Normalized direction from the enemy to its target.
func directionToTarget() -> Vector2:
	return entity.global_position.direction_to(entity.target.global_position)

## Velocity that circles around the target. dirChanger (1 or -1) picks the direction.
func circlingVelocity(dirChanger: int, speed: float) -> Vector2:
	var diffVector = entity.global_position - entity.target.global_position
	var tangent = Vector2(-diffVector.y * dirChanger, diffVector.x * dirChanger).normalized()
	return tangent * speed

## Whether a body other than the enemy itself is inside [param area].
func hasObstacle(area: Area2D, ignorePlayers: bool) -> bool:
	for body in area.get_overlapping_bodies():
		if body == entity or (ignorePlayers and body is Player):
			continue
		return true
	return false
