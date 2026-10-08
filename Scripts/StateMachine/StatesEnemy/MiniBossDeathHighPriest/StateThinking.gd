extends StateEnemy
## Picks the boss's next action at random, weighted by how far away the closest
## player is. Actions that need a sacrifice go through StateSacrifice first.

## Starting weight of each action. Higher means more likely.
@export var baseWeights: Dictionary[String, int] = {
	IDLE: 5,
	STRAFE: 5,
	TELEGRAPH_SWIPE: 5,
	TELEGRAPH_DAGGER_EXPLOSION: 5,
	TELEGRAPH_DAGGER_CONE: 5,
	TELEGRAPH_DAGGER_CIRCLING: 5,
	TELEPORT: 5,
	CAST_SHIELD: 5,
}
@export var meleeRangeThreshold: float = 200.0
@export var tooCloseThreshold: float = 100.0
@export var farEnoughThreshold: float = 300.0

var weights: Dictionary[String, int]
var actionsRequireSacrifice := [
	TELEGRAPH_DAGGER_CIRCLING,
	TELEGRAPH_DAGGER_EXPLOSION,
	CAST_SHIELD
	]

func enter(_previous_state_path: String, _data := {}) -> void:
	#buffer time between each action
	await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
	if not isActive:
		return
	# every decision starts from the base weights and adjusts them for the current situation
	weights = baseWeights.duplicate()
	var closestPlayer: Player = entity.getClosestPlayer()
	var entityPos = entity.global_position
	var distance = entityPos.distance_to(closestPlayer.global_position)

	# player in melee range
	if(distance < meleeRangeThreshold):
		weights[TELEGRAPH_SWIPE] += 5
	# player is too close
	if(distance < tooCloseThreshold):
		weights[TELEGRAPH_SWIPE] += 5
		if(entity.currentShield <= 0):
			weights[TELEGRAPH_DAGGER_CONE] += 5
		weights[TELEGRAPH_DAGGER_EXPLOSION] -= 10
		weights[TELEGRAPH_DAGGER_CIRCLING] -= 10
		weights[TELEPORT] += 5
		weights[CAST_SHIELD] -= 5
	# player is far enough
	if(distance < farEnoughThreshold && distance > meleeRangeThreshold):
		weights[TELEPORT] -= 5
		weights[TELEGRAPH_DAGGER_CONE] += 10
		weights[TELEGRAPH_DAGGER_CIRCLING] += 10
		weights[TELEGRAPH_DAGGER_EXPLOSION] += 10
		weights[CAST_SHIELD] += 10
	# player too far to melee
	if(distance > meleeRangeThreshold):
		weights[TELEGRAPH_SWIPE] = 0
	decideNextState()

func decideNextState() -> void:
	# negative weights count as 0 (never chosen)
	var totalWeight = 0
	for w in weights.values():
		totalWeight += maxi(w, 0)
	if totalWeight <= 0:
		transition(IDLE)
		return
	var r = randi() % totalWeight
	var accumul = 0
	for k in weights:
		accumul += maxi(weights[k], 0)
		if r < accumul :
			if(actionsRequireSacrifice.has(k)):
				transition(SACRIFICE, {"nextState": k})
			else:
				transition(k)
			return
