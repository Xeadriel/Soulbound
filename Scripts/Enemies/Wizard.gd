class_name Wizard extends Enemy

@onready var atkSpawnPoint: Node2D = $AtkSpawnPoint

@export var fireballScene : PackedScene = null
@export var panicRunThresholdDistance := 300
@export var runChance := 0.7

var projectileNode: Node

func _ready() -> void:
	super._ready()
	projectileNode = get_tree().get_first_node_in_group("ProjectileNode")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func takeDamage(dmg: int) -> void:
	currentHp -= dmg

func getDirectionToPlayer() -> Direction:
	var dir = global_position.direction_to(target.global_position)
	
	var angle = dir.angle()
	angle =  rad_to_deg(angle)
	
	return getDirectionFromAngle(angle)

func getDirectionFromVector(dir: Vector2) -> Direction:
	var angle = dir.angle()
	angle =  rad_to_deg(angle)
	
	return getDirectionFromAngle(angle)

func getDirectionFromAngle(angle: float) -> Direction:
	if angle > -45 and angle <= 45:
		return Direction.RIGHT
	elif angle > 135 or angle <= -135:
		return Direction.LEFT
	elif angle < -45 and angle >= -135:
		return Direction.UP
	else: 
		return Direction.DOWN

"""
Animations
"""

func animationFinished():
	animationFinishedSignal.emit(animatedSprite)

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
	var fireball = fireballScene.instantiate()
	var atkDirection = global_position.direction_to(target.global_position)
	atkSpawnPoint.global_position = global_position + atkDirection * 100
	fireball.global_position = atkSpawnPoint.global_position
	fireball.direction = fireball.global_position.direction_to(target.global_position)
	projectileNode.add_child(fireball)
	match direction:
		Direction.UP:
			animatedSprite.play("attackBack")
		Direction.DOWN:
			animatedSprite.play("attackFront")
		Direction.LEFT:
			animatedSprite.play("attackLeft")
		Direction.RIGHT:
			animatedSprite.play("attackRight")

func stopAttack() -> void:
	pass

# signal when area2D collides with something
func hitSomething(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.takeDamage(DAMAGE)
