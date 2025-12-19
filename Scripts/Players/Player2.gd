class_name Player2 extends Player

@export var DAMAGE : int = 1

@export var magicShotSpawner : PackedScene = null

@onready var spawnLocationMagicShot = $AttackPivotPoint/LightAttackSpawnLocation

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
			animatedSprite.play("attackBack" + suffix)
		Direction.DOWN:
			animatedSprite.play("attackFront" + suffix)
		Direction.LEFT:
			animatedSprite.play("attackLeft" + suffix)
		Direction.RIGHT:
			animatedSprite.play("attackRight" + suffix)

	var magicShot = magicShotSpawner.instantiate()
	magicShot.global_position = spawnLocationMagicShot.global_position
	magicShot.player = self
	magicShot.rotation = attackPivotPoint.rotation
	magicShot.direction = Vector2(1, 0).rotated(magicShot.rotation)
	
	get_parent().add_child(magicShot)
	

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

# attacks in facing direction
# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attackHeavy(combo : int) -> void:
	var suffix = "" if combo == 0 else str(combo)
	match direction:
		Direction.UP:
			animatedSprite.play("attackHeavyBack" + suffix)
		Direction.DOWN:
			animatedSprite.play("attackHeavyFront" + suffix)
		Direction.LEFT:
			animatedSprite.play("attackHeavyLeft" + suffix)
		Direction.RIGHT:
			animatedSprite.play("attackHeavyRight" + suffix)

func stopAttackHeavy() -> void:
	
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

func setAttackRotationFromDirection(dir: Vector2) -> void:
	assert(not dir == Vector2.ZERO, "Move direction should never be (0,0)")
	
	attackPivotPoint.rotation = dir.angle()

func setPlayerDirection(dir : Vector2) -> void:
	if dir.y < 0:
		direction = Direction.UP
	elif dir.y > 0:
		direction = Direction.DOWN

	# horizontal direction prioritized over vertical direction
	if dir.x < 0:
		direction = Direction.LEFT
	elif dir.x > 0:
		direction = Direction.RIGHT
