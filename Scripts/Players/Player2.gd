class_name Player2 extends Player
## Mage: fires magic shots and charges up a volley for the heavy attack.

@export var DAMAGE : int = 1

@export var magicShotSpawner : PackedScene = null

@onready var spawnLocationMagicShot : Node2D = $AttackPivotPoint/LightAttackSpawnLocation
@onready var heavyAttackSpawnLocations : Array = $AttackPivotPoint/HeavyAttackSpawnLocations.get_children()

## Which heavy attack spawn locations get a shot at each charge level (1, 2, 3).
const CHARGE_SPAWN_INDICES : Array = [[0], [1], [2, 3, 4]]

var heavyAttackCharges = []

func _ready() -> void:
	super._ready()
	assert(magicShotSpawner != null, "MagicShotSpawner should not be null")

# attacks in facing direction
# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attack(combo : int) -> void:
	super.attack(combo)

	var magicShot = magicShotSpawner.instantiate()
	magicShot.global_position = spawnLocationMagicShot.global_position
	magicShot.player = self
	magicShot.rotation = attackPivotPoint.rotation
	magicShot.direction = Vector2(1, 0).rotated(magicShot.rotation)

	Projectile.spawnParent(get_tree()).add_child(magicShot)

func stopAttack() -> void:
	idleAnimation()

# charges the heavy attack, each charge level spawns more shots
# that wait at their spawn location until released
func chargeAttackHeavy(charge : int) -> void:
	playDirectional("attackHeavy")

	if charge < 1 or charge > CHARGE_SPAWN_INDICES.size():
		return
	for i in CHARGE_SPAWN_INDICES[charge - 1]:
		spawnChargedShot(i)

func spawnChargedShot(spawnIndex : int) -> void:
	var magicShot = magicShotSpawner.instantiate()
	heavyAttackSpawnLocations[spawnIndex].add_child(magicShot)
	heavyAttackCharges.append(magicShot)
	magicShot.global_position = heavyAttackSpawnLocations[spawnIndex].global_position
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
	idleAnimation()
