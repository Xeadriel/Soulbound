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

func getInterrupted(newState : String) -> void:
	pass

## Targets the closest player (by walking distance) and returns the straight-line
## distance to it. INF when there is no player, e.g. when running an enemy scene on its own.
func targetClosestPlayer() -> float:
	entity.target = entity.getClosestPlayer()
	if entity.target == null:
		return INF
	return entity.global_position.distance_to(entity.target.global_position)

## Whether the target is close enough (walking) to start chasing it.
func targetInAggroRange() -> bool:
	return entity.target != null and entity.walkingDistanceTo(entity.target) < entity.aggroRange

## Whether the target got too far away (walking), out of reach, or is gone, to keep chasing it.
func targetOutOfChaseRange() -> bool:
	return entity.target == null or entity.walkingDistanceTo(entity.target) > entity.aggroRange * entity.giveUpFactor

## Whether nothing solid is between the enemy and its target.
func canSeeTarget() -> bool:
	return entity.target != null and entity.hasLineOfSightTo(entity.target)

## Normalized direction from the enemy to its target.
func directionToTarget() -> Vector2:
	return entity.global_position.direction_to(entity.target.global_position)

## Runs along the navigation path to the target, around walls and world objects.
## Stands facing the target when there is nowhere closer to go.
func runTowardsTarget(speed: float) -> void:
	runTo(entity.target.global_position, speed)

## Runs along the navigation path to [param destination], around walls and world objects.
## Stands facing the target when there is nowhere closer to go.
func runTo(destination: Vector2, speed: float) -> void:
	var direction := entity.pathDirectionTo(destination)
	entity.velocity = direction * speed
	if direction == Vector2.ZERO:
		entity.facing = entity.getDirectionToPlayer()
		entity.idle()
	else:
		entity.facing = Facing.fromVector(direction)
		entity.run()

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
