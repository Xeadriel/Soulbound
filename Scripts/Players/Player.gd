class_name Player extends CharacterBody2D

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

signal playerDeath
signal playerTakesDamage

@export var maxHp = 6
@export var hp = 6

var direction = Direction.DOWN

@onready var stateMachine = $StateMachine

@onready var attackPivotPoint : Node2D = $AttackPivotPoint

@export var whipAttackSpawner : PackedScene =  null
@onready var spawnLocationWhipAttack = $AttackPivotPoint/WhipAttack/Start 
@onready var goalWhipAttack = $AttackPivotPoint/WhipAttack/Goal

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
	hp = clamp(hp - 1, 0, self.maxHp)
	if hp <= 0:
		var playerNumber = 2 if name == "Player2" else 1
		playerDeath.emit(playerNumber)

	playerTakesDamage.emit(dmg)

# attacks in facing direction
# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attack(combo : int) -> void:
	var suffix = "" if combo == 0 else str(combo)
	match direction:
		Direction.UP:
			animatedSprite.play("attackBack" + suffix)
		Direction.DOWN:
			animatedSprite.play("attackFront" + suffix)
		Direction.LEFT:
			animatedSprite.play("attackLeft" + suffix)
		Direction.RIGHT:
			animatedSprite.play("attackRight" + suffix)

func stopAttack() -> void:
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

func dash() -> void:
	collision_layer = collision_layer & 0b0 #become unhittable
	match direction:
		Direction.UP:
			animatedSprite.play("dashBack")
		Direction.DOWN:
			animatedSprite.play("dashFront")
		Direction.LEFT:
			animatedSprite.play("dashLeft")
		Direction.RIGHT:
			animatedSprite.play("dashRight")

func stopDash() -> void:
	collision_layer = collision_layer | 0b1 #become hittable
	match direction:
		Direction.UP:
			animatedSprite.play("idleBack")
		Direction.DOWN:
			animatedSprite.play("idleFront")	
		Direction.LEFT:
			animatedSprite.play("idleLeft")
		Direction.RIGHT:
			animatedSprite.play("idleRight")

func whipAttack():
	#match direction:
		#Direction.UP:
			#animatedSprite.play("attackBack")
		#Direction.DOWN:
			#animatedSprite.play("attackFront")
		#Direction.LEFT:
			#animatedSprite.play("attackLeft")
		#Direction.RIGHT:
			#animatedSprite.play("attackRight")

	var whip = whipAttackSpawner.instantiate()
	whip.global_position = spawnLocationWhipAttack.global_position
	whip.player = self
	whip.rotation = attackPivotPoint.rotation
	whip.direction = Vector2(1, 0).rotated(whip.rotation)
	
	get_parent().add_child(whip)

func stopWhipAttack():
		match direction:
			Direction.UP:
				animatedSprite.play("idleBack")
			Direction.DOWN:
				animatedSprite.play("idleFront")	
			Direction.LEFT:
				animatedSprite.play("idleLeft")
			Direction.RIGHT:
				animatedSprite.play("idleRight")
