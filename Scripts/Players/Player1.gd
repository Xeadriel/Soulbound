class_name Player1 extends Player

@export var LIGHT_DAMAGE = 1
@export var HEAVY_DAMAGE = 2

@onready var lightAttacks : Array = $AttackPivotPoint/LightAttacks.get_children()
@onready var heavyAttacks : Array = $AttackPivotPoint/HeavyAttacks.get_children()

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
	
	
	lightAttacks[combo-1].visible = false
	lightAttacks[combo-1].process_mode = PROCESS_MODE_DISABLED

	lightAttacks[combo].visible = true
	lightAttacks[combo].process_mode = PROCESS_MODE_INHERIT

func stopAttack() -> void:
	for atk in lightAttacks:
		atk.visible = false
		atk.process_mode = PROCESS_MODE_DISABLED
	
	match direction:
		Direction.UP:
			animatedSprite.play("idleBack")
		Direction.DOWN:
			animatedSprite.play("idleFront")	
		Direction.LEFT:
			animatedSprite.play("idleLeft")
		Direction.RIGHT:
			animatedSprite.play("idleRight")

# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attackHeavyWindup(combo : int) -> void:
	var suffix = "" if combo == 0 else str(combo)
	animatedSprite.stop()
	match direction:
		Direction.UP:
			animatedSprite.play("attackHeavyBack" + suffix)
		Direction.DOWN:
			animatedSprite.play("attackHeavyFront" + suffix)
		Direction.LEFT:
			animatedSprite.play("attackHeavyLeft" + suffix)
		Direction.RIGHT:
			animatedSprite.play("attackHeavyRight" + suffix)

# attacks in facing direction, combo decides which hitbox is used
func attackHeavy(combo : int) -> void:
	heavyAttacks[combo-1].visible = false
	heavyAttacks[combo-1].process_mode = PROCESS_MODE_DISABLED

	heavyAttacks[combo].visible = true
	heavyAttacks[combo].process_mode = PROCESS_MODE_INHERIT

func stopAttackHeavy() -> void:
	for atk in heavyAttacks:
		atk.visible = false
		atk.process_mode = PROCESS_MODE_DISABLED
	
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

# signal when one of the light attacks area2D collides with something
func lightAttackHitSomething(body: Node2D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.takeDamage(LIGHT_DAMAGE)

# signal when one of the heavy attacks area2D collides with something
func heavyAttackHitSomething(body: Node2D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.takeDamage(HEAVY_DAMAGE)
