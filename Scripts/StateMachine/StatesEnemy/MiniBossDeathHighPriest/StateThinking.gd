extends StateEnemy

var weights: Dictionary[String, int]
var meleeRangeThreshold: float = 200.0
var tooCloseThreshold: float = 100.0
var farEnoughThreshold: float = 300.0
var actionsRequireSacrifice := [
	TELEGRAPH_DAGGER_CIRCLING, 
	TELEGRAPH_DAGGER_EXPLOSION, 
	CAST_SHIELD
	]

func _ready() -> void:
	weights[IDLE] = 5
	weights[STRAFE] = 5
	weights[TELEGRAPH_SWIPE] = 5
	weights[TELEGRAPH_DAGGER_EXPLOSION] = 5
	weights[TELEGRAPH_DAGGER_CONE] = 5
	weights[TELEGRAPH_DAGGER_CIRCLING] = 5
	weights[TELEPORT] = 5
	weights[CAST_SHIELD] = 5

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	
	await get_tree().create_timer(randf_range(2.0, 4.0)).timeout
	
	var closestPlayer: Player = entity.getClosestPlayer()
	var entityPos = entity.global_position
	var distance = entityPos.distance_to(closestPlayer.global_position)
	
	weights[TELEGRAPH_DAGGER_EXPLOSION] += 500
	
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

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass

func decideNextState() -> void:
	var totalWeight = 0
	for w in weights.values():
		totalWeight += w
	var r = randi() % totalWeight
	var accumul = 0
	for k in weights:
		accumul += weights[k]
		if r < accumul :
			if(actionsRequireSacrifice.has(k)):
				finished.emit(SACRIFICE, {"nextState": k})
			else:
				finished.emit(k)
			return
