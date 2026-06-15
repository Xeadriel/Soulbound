## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
extends StateNamesMiniBossDeathHighPriest

@export var SPEED : float = 100.0
@export var minDuration4DirChange: float = 1
@export var maxDuration4DirChange: float = 5

@export var minDuration4Telegraph: float = 1
@export var maxDuration4Telegraph: float = 2

@export var duration4Obstacle: float = 0.5

# when the distance is slightly off its fine but otherwise needs correction
@export var distanceThreshold: float = 100

@export var obstacleDetection: Area2D

var dirChanger: int = [-1, 1][randi() % 2]
var timer4DirChange: float = 5.0
var timer4Obstacle: float = 0.0

## Called by the state machine when receiving unhandled input events.
func handleInput() -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func process(delta: float) -> void:
	entity.target = entity.getClosestPlayer()
	var distance = entity.global_position.distance_to(entity.target.global_position)
	var inRangeThresh: bool = entity.atkRange + distanceThreshold >= distance
	
	timer4DirChange -= delta
	timer4Obstacle -= delta
	
	var potentialObstacles = obstacleDetection.get_overlapping_bodies()
	if not potentialObstacles.is_empty() and timer4Obstacle <= 0:
		for o in potentialObstacles:
			if not o == entity and o is not Player:
				dirChanger = -dirChanger
				timer4Obstacle = duration4Obstacle
				break
				
	# if enemy is too far away
	if distance > entity.atkRange:
		entity.velocity = entity.global_position.direction_to(
			entity.target.global_position).normalized() * SPEED
		entity.run()
	if entity.target && inRangeThresh && timer4DirChange > 0:
		# if enemy is too close
		if distance < entity.atkRange - distanceThreshold:
				entity.velocity = entity.global_position.direction_to(
					entity.target.global_position).normalized() * SPEED * -1
		else:
			var diffVector = entity.global_position - entity.target.global_position
			var tangent = Vector2(-diffVector.y * dirChanger, 
				diffVector.x * dirChanger).normalized()
			entity.velocity = tangent * SPEED
		
		entity.direction = entity.getDirectionToPlayer()
		entity.run()
	elif inRangeThresh && timer4DirChange <= 0:
		timer4DirChange = randf_range(minDuration4DirChange, maxDuration4DirChange)
		dirChanger = -dirChanger
	else:
		finished.emit(THINKING)

## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	pass

func exit() -> void:
	pass
