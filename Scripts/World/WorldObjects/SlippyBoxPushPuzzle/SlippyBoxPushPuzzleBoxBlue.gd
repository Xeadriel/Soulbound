class_name SlippyBoxPushPuzzleBoxBlue extends CharacterBody2D

const SPEED = 300.0

var previousPos : Vector2

func _ready() -> void:
	previousPos = position

func _physics_process(delta: float) -> void:
	move_and_slide()
	var distance = previousPos.distance_to(position)
	previousPos = position
	
	if distance <= 1:
		velocity.x = 0
		velocity.y = 0

func onPushedUp():
	if velocity.x == 0 and velocity.y == 0:
		velocity.y = -SPEED

func onPushedDown():
	if velocity.x == 0 and velocity.y == 0:
		velocity.y = SPEED

func onPushedLeft():
	if velocity.x == 0 and velocity.y == 0:
		velocity.x = -SPEED

func onPushedRight():
	if velocity.x == 0 and velocity.y == 0:
		velocity.x = SPEED

func reachGoal():
	set_physics_process(false)
