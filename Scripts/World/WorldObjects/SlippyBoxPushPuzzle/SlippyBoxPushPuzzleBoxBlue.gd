class_name SlippyBoxPushPuzzleBoxBlue extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	if 0 < velocity.x + velocity.y and velocity.x + velocity.y < 300:
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

func onPushedUp():
	velocity.y = -SPEED

func onPushedDown():
	velocity.y = SPEED

func onPushedLeft():
	velocity.x = -SPEED

func onPushedRight():
	velocity.x = SPEED

func reachGoal():
	set_physics_process(false)
