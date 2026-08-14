class_name Enemy extends CharacterBody2D

@export var maxHp := 3
@export var atkRange := 100.0
@export var aggroRange:= 500.0
@export var telegraphTime := 1.0


var players
var target: Player

@onready var stateMachine = $StateMachine

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
var currentHp: int:
	set(newHP):
		currentHp = newHP
		if currentHp < 1:
			died.emit()
			queue_free()

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

signal animationFinishedSignal
signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHp = maxHp
	animatedSprite.animation_finished.connect(animationFinished)
	players = get_tree().get_nodes_in_group("Players")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func takeDamage(dmg: int) -> void:
	currentHp -= dmg

func hitByWhip():
	stateMachine._transition_to_next_state("StateStunned", {"duration" : 1.0})

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
		
func getClosestPlayer() -> Player:
	var closestPlayer: Player
	var closestDistance = INF
	for p in players:
		var distanceToPlayer = p.global_position.distance_to(global_position)
		if(distanceToPlayer < closestDistance):
			closestDistance = distanceToPlayer
			closestPlayer = p
	return closestPlayer


"""
Animations
"""

func animationFinished():
	animationFinishedSignal.emit(animatedSprite.animation)

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

func stunned():
	match direction:
		Direction.UP:
			animatedSprite.play("stunnedBack")
		Direction.DOWN:
			animatedSprite.play("stunnedFront")	
		Direction.LEFT:
			animatedSprite.play("stunnedLeft")
		Direction.RIGHT:
			animatedSprite.play("stunnedRight")

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
