class_name Player1 extends Player

@export var LIGHT_DAMAGE = 1
@export var HEAVY_DAMAGE = 2

@onready var lightAttacks : Array = $AttackPivotPoint/LightAttacks.get_children()
@onready var heavyAttacks : Array = $AttackPivotPoint/HeavyAttacks.get_children()

func _ready() -> void:
	super._ready()

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func runAnimation():
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("runBack")
		DIRECTION.DOWN:
			animatedSprite.play("runFront")	
		DIRECTION.LEFT:
			animatedSprite.play("runLeft")
		DIRECTION.RIGHT:
			animatedSprite.play("runRight")

func idleAnimation():
	match facingDirection:
			DIRECTION.UP:
				animatedSprite.play("idleBack")
			DIRECTION.DOWN:
				animatedSprite.play("idleFront")	
			DIRECTION.LEFT:
				animatedSprite.play("idleLeft")
			DIRECTION.RIGHT:
				animatedSprite.play("idleRight")

# attacks in facing direction
# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attack(combo : int) -> void:
	var suffix = "" if combo == 0 else str(combo)
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("attackBack" + suffix)
		DIRECTION.DOWN:
			animatedSprite.play("attackFront" + suffix)
		DIRECTION.LEFT:
			animatedSprite.play("attackLeft" + suffix)
		DIRECTION.RIGHT:
			animatedSprite.play("attackRight" + suffix)
	lightAttacks[combo-1].visible = false
	lightAttacks[combo-1].process_mode = PROCESS_MODE_DISABLED

	lightAttacks[combo].visible = true
	lightAttacks[combo].process_mode = PROCESS_MODE_INHERIT

func stopAttack() -> void:
	for atk in lightAttacks:
		atk.visible = false
		atk.process_mode = PROCESS_MODE_DISABLED

# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attackHeavyWindup(combo : int) -> void:
	var suffix = "" if combo == 0 else str(combo)
	animatedSprite.stop()
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("attackHeavyBack" + suffix)
		DIRECTION.DOWN:
			animatedSprite.play("attackHeavyFront" + suffix)
		DIRECTION.LEFT:
			animatedSprite.play("attackHeavyLeft" + suffix)
		DIRECTION.RIGHT:
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

# blocks in facing direction
func blockIdleAnimation() -> void:
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("blockBack")
		DIRECTION.DOWN:
			animatedSprite.play("blockFront")
		DIRECTION.LEFT:
			animatedSprite.play("blockLeft")
		DIRECTION.RIGHT:
			animatedSprite.play("blockRight")
			
func blockRunAnimation() -> void:
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("blockBack")
		DIRECTION.DOWN:
			animatedSprite.play("blockFront")
		DIRECTION.LEFT:
			animatedSprite.play("blockLeft")
		DIRECTION.RIGHT:
			animatedSprite.play("blockRight")

func setAttackRotationFromDirection(dir: Vector2) -> void:
	assert(not dir == Vector2.ZERO, "Move direction should never be (0,0)")
	
	attackPivotPoint.rotation = dir.angle()

func setPlayerDirection(dir : Vector2) -> void:
	if dir.y < 0:
		facingDirection = DIRECTION.UP
	elif dir.y > 0:
		facingDirection = DIRECTION.DOWN

	# horizontal direction prioritized over vertical direction
	if dir.x < 0:
		facingDirection = DIRECTION.LEFT
	elif dir.x > 0:
		facingDirection = DIRECTION.RIGHT

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
