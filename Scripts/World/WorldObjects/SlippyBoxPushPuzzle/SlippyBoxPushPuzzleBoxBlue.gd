class_name SlippyBoxPushPuzzleBoxBlue extends CharacterBody2D

const SPEED = 300.0

var previousPos : Vector2
var moving : bool = false

signal stoppedMoving
signal startedMoving

func _ready() -> void:
	previousPos = position

func _physics_process(delta: float) -> void:
	move_and_slide()
	var distance = previousPos.distance_to(position)
	previousPos = position
	
	if distance <= 1 and moving:
		velocity.x = 0
		velocity.y = 0
		
		stoppedMoving.emit()
		moving = false

func onPushedUp():
	if velocity.x == 0 and velocity.y == 0:
		velocity.y = -SPEED
		moving = true
		startedMoving.emit()

func onPushedDown():
	if velocity.x == 0 and velocity.y == 0:
		velocity.y = SPEED
		moving = true
		startedMoving.emit()

func onPushedLeft():
	if velocity.x == 0 and velocity.y == 0:
		velocity.x = -SPEED
		moving = true
		startedMoving.emit()

func onPushedRight():
	if velocity.x == 0 and velocity.y == 0:
		velocity.x = SPEED
		moving = true
		startedMoving.emit()

func solved():
	set_physics_process(false)
