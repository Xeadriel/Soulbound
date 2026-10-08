class_name Player extends Character

## 0 for the first player, 1 for the second. Used everywhere the players need to be told apart.
@export var playerIndex : int = 0
@export var inputProfile : PlayerInputProfile
@export var ItemQuickSlots : ItemQuickSelect

@onready var attackPivotPoint : Node2D = $AttackPivotPoint

@export var whipAttackSpawner : PackedScene = null
@onready var spawnLocationWhipAttack : Node2D = $AttackPivotPoint/WhipAttack/Start
@onready var goalWhipAttackGoal : Node2D = $AttackPivotPoint/WhipAttack/Goal

# this is set by an object when getting close enough to it's interact range
# null means there is none right now
# the state machine checks this when the interact button is pressed
var interactableObject : WorldObject = null
var isBlocking : bool = false

func _ready() -> void:
	assert(inputProfile != null, "inputProfile should not be null")
	assert(ItemQuickSlots != null, "ItemQuickSlots should not be null")
	assert(whipAttackSpawner != null, "WhipAttackSpawner should not be null" )
	hp = maxHp
	died.connect(_onDied)

func _onDied() -> void:
	EventBus.playerDied.emit(playerIndex)

func getQuickSlotItemID(index : GlobalConstants.QuickSlotIndices):
	return ItemQuickSlots.quickSlots[index].id

# there could be other conditions here later if needed
func canQuickSlotItemBeUsed(index : GlobalConstants.QuickSlotIndices):
	return ItemQuickSlots.quickSlots[index].itemAmount >= 1

func takeDamage(dmg, dmgSource: Node2D):
	var hitFrom := Facing.fromDominantAxis(dmgSource.global_position - global_position)
	if isBlocking and facing == hitFrom:
		return
	hp -= dmg
	hp = clamp(hp - 1, 0, maxHp)
	if hp <= 0:
		died.emit()
	damaged.emit(dmg)

# --- facing ---

func setPlayerDirection(dir : Vector2) -> void:
	facing = Facing.fromInput(dir, facing)

func setAttackRotationFromDirection(dir: Vector2) -> void:
	assert(not dir == Vector2.ZERO, "Move direction should never be (0,0)")
	attackPivotPoint.rotation = dir.angle()

# --- animations ---

func idleAnimation() -> void:
	playDirectional("idle")

func runAnimation() -> void:
	playDirectional("run")

# blocks in facing direction
func blockIdleAnimation() -> void:
	playDirectional("block")

func blockRunAnimation() -> void:
	blockIdleAnimation()

# --- actions ---

# attacks in facing direction
# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attack(combo : int) -> void:
	playDirectional("attack", "" if combo == 0 else str(combo))

func dash() -> void:
	collision_layer = collision_layer & 0b0 #become unhittable
	playDirectional("dash")

func stopDash() -> void:
	collision_layer = collision_layer | 0b1 #become hittable
	idleAnimation()

func whipAttack(attackDelay):
	var whip = whipAttackSpawner.instantiate()
	whip.global_position = spawnLocationWhipAttack.global_position
	whip.rotation = attackPivotPoint.rotation
	whip.goal = goalWhipAttackGoal.global_position
	whip.attackDelay = attackDelay
	whip.player = self

	get_parent().add_child(whip)

func stopWhipAttack():
	idleAnimation()

func setInteractable(object : WorldObject) -> void:
	interactableObject = object
