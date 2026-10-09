extends StateEnemy
## Strafes around the closest player for a short random time, keeping some distance.

@export var minDuration4DirChange: float = 1
@export var maxDuration4DirChange: float = 5

@export var minDuration4Telegraph: float = 1
@export var maxDuration4Telegraph: float = 2

@export var duration4Obstacle: float = 0.5

# when the distance is slightly off its fine but otherwise needs correction
@export var distanceThreshold: float = 100

@export var obstacleDetection: Area2D

var runDuration : float

var dirChanger: int = [-1, 1][randi() % 2]
var timer4DirChange: float = 5.0
var timer4Obstacle: float = 0.0

func process(delta: float) -> void:
	if runDuration <= 0:
		transition(THINKING)
		return
	runDuration -= delta
	var distance := targetClosestPlayer()
	var inRangeThresh: bool = entity.atkRange + distanceThreshold >= distance

	timer4DirChange -= delta
	timer4Obstacle -= delta

	if timer4Obstacle <= 0 and hasObstacle(obstacleDetection, true):
		dirChanger = -dirChanger
		timer4Obstacle = duration4Obstacle

	# if enemy is too far away
	if distance > entity.atkRange:
		entity.velocity = directionToTarget() * entity.SPEED
		entity.run()
	if entity.target && inRangeThresh && timer4DirChange > 0:
		# if enemy is too close
		if distance < entity.atkRange - distanceThreshold:
			entity.velocity = directionToTarget() * entity.SPEED * -1
		else:
			entity.velocity = circlingVelocity(dirChanger, entity.SPEED)

		entity.facing = entity.getDirectionToPlayer()
		entity.run()
	elif inRangeThresh && timer4DirChange <= 0:
		timer4DirChange = randf_range(minDuration4DirChange, maxDuration4DirChange)
		dirChanger = -dirChanger
	else:
		transition(THINKING)

func enter(_previous_state_path: String, _data := {}) -> void:
	runDuration = randf_range(1.0, 2.0)
