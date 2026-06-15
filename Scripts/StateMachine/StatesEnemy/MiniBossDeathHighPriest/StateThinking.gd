extends StateNamesMiniBossDeathHighPriest

var weights: Dictionary[String, float]
var meleeRangeThreshold: float = 200.0
var tooCloseThreshold: float = 100.0
var farEnoughThreshold: float = 300.0

func _ready() -> void:
	weights[IDLE] = 0
	weights[STRAFE] = 0
	weights[TELEGRAPH_SWIPE] = 0
	weights[STUNNED] = 0
	weights[SACRIFICE] = 0
	weights[TELEGRAPH_DAGGER_EXPLOSION] = 0
	weights[TELEGRAPH_DAGGER_CONE] = 0
	weights[TELEGRAPH_DAGGER_CIRCLING] = 0
	weights[TELEPORT] = 0
	weights[CAST_SHIELD] = 0

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	var closesPlayer: Player = entity.getClosestPlayer()
	var entityPos = entity.global_position
	var distance = entityPos.distance_to(closesPlayer.global_position)
	# player in melee range
	if(distance < meleeRangeThreshold):
		weights[TELEGRAPH_SWIPE] += 5
	# player is too close
	if(distance < tooCloseThreshold):
		weights[TELEGRAPH_SWIPE] += 5
		if(false): # todo: has shield
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
	
## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass

func decideNextState() -> void:
	var totalWeight = 0
	for w in weights.values():
		totalWeight += w
	var r = randi() % totalWeight
	for k in weights:
		var w = weights[k]
		if r < w :
			finished.emit(k)
			return
