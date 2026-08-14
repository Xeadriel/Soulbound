class_name Goblin extends Enemy
# Called every frame. 'delta' is the elapsed time since the previous frame.

@export var SPEED := 100

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func takeDamage(dmg: int) -> void:
	currentHp -= dmg

"""
Animations
"""

func idle():
	match direction:
		Direction.UP:
			animatedSprite.play("idleBack")
		Direction.DOWN:
			animatedSprite.play("idleFront")
		Direction.LEFT:
			animatedSprite.play("idleLeft")
		Direction.RIGHT:
			animatedSprite.play("idleRight")

func run():
	match direction:
		Direction.UP:
			animatedSprite.play("runBack")
		Direction.DOWN:
			animatedSprite.play("runFront")
		Direction.LEFT:
			animatedSprite.play("runLeft")
		Direction.RIGHT:
			animatedSprite.play("runRight")

func telegraphAttack() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("telegraphBack")
		Direction.DOWN:
			animatedSprite.play("telegraphFront")	
		Direction.LEFT:
			animatedSprite.play("telegraphLeft")
		Direction.RIGHT:
			animatedSprite.play("telegraphRight")

func attack() -> void:
	match direction:
		Direction.UP:
			attackUp.process_mode = PROCESS_MODE_INHERIT
			attackUp.visible = true
			animatedSprite.play("attackBack")
		Direction.DOWN:
			attackDown.process_mode = PROCESS_MODE_INHERIT
			attackDown.visible = true
			animatedSprite.play("attackFront")
		Direction.LEFT:
			attackLeft.process_mode = PROCESS_MODE_INHERIT
			attackLeft.visible = true
			animatedSprite.play("attackLeft")
		Direction.RIGHT:
			attackRight.process_mode = PROCESS_MODE_INHERIT
			attackRight.visible = true
			animatedSprite.play("attackRight")

func stopAttack() -> void:
	attackUp.visible = false
	attackDown.visible = false
	attackLeft.visible = false
	attackRight.visible = false
	attackUp.process_mode = PROCESS_MODE_DISABLED
	attackDown.process_mode = PROCESS_MODE_DISABLED
	attackLeft.process_mode = PROCESS_MODE_DISABLED
	attackRight.process_mode = PROCESS_MODE_DISABLED

# signal when area2D collides with something
func hitSomething(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.takeDamage(DAMAGE)
