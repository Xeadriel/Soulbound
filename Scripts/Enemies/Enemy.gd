class_name Enemy extends CharacterBody2D

@export var maxHp := 3
@export var atkRange := 100.0
@export var aggroRange:= 500.0
@export var telegraphTime := 1.0

var target: Player

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var direction = Direction.DOWN

@onready var attackUp : Area2D = $AttackUp
@onready var attackDown : Area2D = $AttackDown
@onready var attackLeft : Area2D = $AttackLeft
@onready var attackRight : Area2D= $AttackRight

@export var DAMAGE = 1
@export var currentHp: int:
	set(newHP):
		currentHp = newHP
		if currentHp < 1:
			queue_free()

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
signal animationFinishedSignal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHp = maxHp
	animatedSprite.animation_finished.connect(animationFinished)
	

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

# signal when area2D collides with something
func hitSomething(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.takeDamage(DAMAGE)
