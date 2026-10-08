class_name Player2 extends Player

@export var DAMAGE : int = 1

@export var magicShotSpawner : PackedScene = null

@onready var spawnLocationMagicShot = $AttackPivotPoint/LightAttackSpawnLocation
@onready var heavyAttackSpawnLocations = $AttackPivotPoint/HeavyAttackSpawnLocations.get_children()

var heavyAttackCharges = []
var projecttileNode: Node

func _ready() -> void:
	super._ready()
	assert(magicShotSpawner != null, "MagicShotSpawner should not be null")
	projecttileNode = get_tree().get_first_node_in_group("ProjectileNode")

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

	var magicShot = magicShotSpawner.instantiate()
	magicShot.global_position = spawnLocationMagicShot.global_position
	magicShot.player = self
	magicShot.rotation = attackPivotPoint.rotation
	magicShot.direction = Vector2(1, 0).rotated(magicShot.rotation)
	
	projecttileNode.add_child(magicShot)

func stopAttack() -> void:
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
func chargeAttackHeavy(charge : int) -> void:
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("attackHeavyBack")
		DIRECTION.DOWN:
			animatedSprite.play("attackHeavyFront")
		DIRECTION.LEFT:
			animatedSprite.play("attackHeavyLeft")
		DIRECTION.RIGHT:
			animatedSprite.play("attackHeavyRight")
	
	match charge:
		1:
			var magicShot = magicShotSpawner.instantiate()
			heavyAttackSpawnLocations[0].add_child(magicShot)
			heavyAttackCharges.append(magicShot)
			magicShot.global_position = heavyAttackSpawnLocations[0].global_position
			magicShot.player = self
			magicShot.direction = Vector2(1, 0).rotated(attackPivotPoint.rotation)
			
			magicShot.waitForRelease()
		2:
			var magicShot = magicShotSpawner.instantiate()
			heavyAttackSpawnLocations[1].add_child(magicShot)
			heavyAttackCharges.append(magicShot)
			magicShot.global_position = heavyAttackSpawnLocations[1].global_position
			magicShot.player = self
			magicShot.direction = Vector2(1, 0).rotated(attackPivotPoint.rotation)
			
			magicShot.waitForRelease()
		3:
			for i in range(2, 5):
				var magicShot = magicShotSpawner.instantiate()
				heavyAttackSpawnLocations[i].add_child(magicShot)
				heavyAttackCharges.append(magicShot)
				magicShot.global_position = heavyAttackSpawnLocations[i].global_position
				magicShot.player = self
				magicShot.direction = Vector2(1, 0).rotated(attackPivotPoint.rotation)
				
				magicShot.waitForRelease()

func releaseAttackHeavy():
	for i in range(len(heavyAttackCharges)):
		heavyAttackSpawnLocations[i].remove_child(heavyAttackCharges[i])
		get_parent().add_child(heavyAttackCharges[i])
		heavyAttackCharges[i].global_position = heavyAttackSpawnLocations[i].global_position
		heavyAttackCharges[i].player = self
		heavyAttackCharges[i].direction = Vector2(1, 0).rotated(attackPivotPoint.rotation)
		heavyAttackCharges[i].rotation = attackPivotPoint.rotation
		
		heavyAttackCharges[i].release()

	heavyAttackCharges = []

func stopAttackHeavy() -> void:
	
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("idleBack")
		DIRECTION.DOWN:
			animatedSprite.play("idleFront")	
		DIRECTION.LEFT:
			animatedSprite.play("idleLeft")
		DIRECTION.RIGHT:
			animatedSprite.play("idleRight")

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
	#for charge in heavyAttackCharges:
		#charge.rotation = charge.direction.angle()

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
