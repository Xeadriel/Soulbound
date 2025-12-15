class_name Player extends CharacterBody2D

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

signal playerDeath
signal playerTakesDamage

@export var maxHp = 3
@export var hp = 3
@export var DAMAGE = 1

var direction = Direction.DOWN

@onready var stateMachine = $StateMachine

@onready var attackUp : Area2D = $AttackUp
@onready var attackDown : Area2D = $AttackDown
@onready var attackLeft : Area2D = $AttackLeft
@onready var attackRight : Area2D= $AttackRight

var blockTimeStamp = 0
@export var blockDelay = 500

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	playerDeath.connect(EventHandler.playerDied)

func _process(_delta) -> void:
	if "block" in animatedSprite.animation or "attack" in animatedSprite.animation:
		return
	if velocity.x != 0 or velocity.y != 0:
		match direction:
			Direction.UP:
				animatedSprite.play("runBack")
			Direction.DOWN:
				animatedSprite.play("runFront")	
			Direction.LEFT:
				animatedSprite.play("runLeft")
			Direction.RIGHT:
				animatedSprite.play("runRight")
	else:
		match direction:
			Direction.UP:
				animatedSprite.play("idleBack")
			Direction.DOWN:
				animatedSprite.play("idleFront")	
			Direction.LEFT:
				animatedSprite.play("idleLeft")
			Direction.RIGHT:
				animatedSprite.play("idleRight")

func _physics_process(_delta: float) -> void:
	move_and_slide()

func takeDamage(dmg):
	if stateMachine.currentState.name == "StateBlock" and blockTimeStamp + blockDelay >= Time.get_ticks_msec():
		# spawn some block particle and make sound
		return
	hp -= dmg
	if hp <= 0:
		var playerNumber = 2 if name == "Player2" else 1
		playerDeath.emit(playerNumber)
		if hp < 0:
			return
	playerTakesDamage.emit(dmg)

# attacks in facing direction
# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attack(combo : int) -> void:
	var suffix = "" if combo == 0 else str(combo)
	match direction:
		Direction.UP:
			attackUp.process_mode = PROCESS_MODE_INHERIT
			attackUp.visible = true
			animatedSprite.play("attackBack" + suffix)
		Direction.DOWN:
			attackDown.process_mode = PROCESS_MODE_INHERIT
			attackDown.visible = true
			animatedSprite.play("attackFront" + suffix)
		Direction.LEFT:
			attackLeft.process_mode = PROCESS_MODE_INHERIT
			attackLeft.visible = true
			animatedSprite.play("attackLeft" + suffix)
		Direction.RIGHT:
			attackRight.process_mode = PROCESS_MODE_INHERIT
			attackRight.visible = true
			animatedSprite.play("attackRight" + suffix)

func stopAttack() -> void:
	attackUp.visible = false
	attackDown.visible = false
	attackLeft.visible = false
	attackRight.visible = false
	attackUp.process_mode = PROCESS_MODE_DISABLED
	attackDown.process_mode = PROCESS_MODE_DISABLED
	attackLeft.process_mode = PROCESS_MODE_DISABLED
	attackRight.process_mode = PROCESS_MODE_DISABLED
	
	match direction:
		Direction.UP:
			animatedSprite.play("idleBack")
		Direction.DOWN:
			animatedSprite.play("idleFront")	
		Direction.LEFT:
			animatedSprite.play("idleLeft")
		Direction.RIGHT:
			animatedSprite.play("idleRight")


# blocks in facing direction
func block() -> void:
	blockTimeStamp = Time.get_ticks_msec()
	# add animation
	match direction:
		Direction.UP:
			animatedSprite.play("blockBack")
		Direction.DOWN:
			animatedSprite.play("blockFront")
		Direction.LEFT:
			animatedSprite.play("blockLeft")
		Direction.RIGHT:
			animatedSprite.play("blockRight")

func stopBlock() -> void:
	blockTimeStamp = 0
	match direction:
		Direction.UP:
			animatedSprite.play("idleBack")
		Direction.DOWN:
			animatedSprite.play("idleFront")	
		Direction.LEFT:
			animatedSprite.play("idleLeft")
		Direction.RIGHT:
			animatedSprite.play("idleRight")

# signal when area2D collides with something
func swordHitSomething(body: Node2D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.takeDamage(DAMAGE)
