extends StateEnemy
## Circles around the target at attack range, changing direction now and then,
## until it is time to attack.

@export var SPEED : float = 100.0
@export var minDuration4DirChange: float = 3
@export var maxDuration4DirChange: float = 7

@export var minDuration4Telegraph: float = 1
@export var maxDuration4Telegraph: float = 5

@export var duration4Obstacle: float = 0.5

# when the distance is slightly off its fine but otherwise needs correction
@export var distanceThreshold: float = 10

@export var obstacleDetection: Area2D

var dirChanger: int = [-1, 1][randi() % 2]
var timer4DirChange: float

var timer4Obstacle: float = 0.0

var timer4Telegraph: float

func process(delta: float) -> void:
	var distance := targetClosestPlayer()
	var inRangeThresh: bool = entity.atkRange + distanceThreshold >= distance

	timer4DirChange -= delta
	timer4Telegraph -= delta
	timer4Obstacle -= delta

	if timer4Obstacle <= 0 and hasObstacle(obstacleDetection, false):
		dirChanger = -dirChanger
		timer4Obstacle = duration4Obstacle

	if entity.target && inRangeThresh && timer4DirChange > 0 && timer4Telegraph > 0:
		# if enemy is too close
		if distance < entity.atkRange - distanceThreshold:
			entity.velocity = directionToTarget() * SPEED * -1
		# if enemy is too far away
		elif distance > entity.atkRange:
			entity.velocity = directionToTarget() * SPEED
		else:
			entity.velocity = circlingVelocity(dirChanger, SPEED)

		entity.facing = entity.getDirectionToPlayer()
		entity.run()
	elif entity.atkRange >= distance && timer4Telegraph:
		transition(TELEGRAPH)
	elif inRangeThresh && timer4DirChange <= 0:
		timer4DirChange = randf_range(minDuration4DirChange, maxDuration4DirChange)
		dirChanger = -dirChanger
	else:
		transition(RUN)

func enter(_previous_state_path: String, _data := {}) -> void:
	if timer4DirChange < 0.5:
		dirChanger = -dirChanger
		timer4DirChange = randf_range(minDuration4DirChange, maxDuration4DirChange)
	if timer4Telegraph < 0.5:
		timer4Telegraph = randf_range(minDuration4Telegraph, maxDuration4Telegraph)
