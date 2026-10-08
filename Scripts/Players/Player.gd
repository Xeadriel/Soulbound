class_name Player extends Character

## 0 for the first player, 1 for the second. Used everywhere the players need to be told apart.
@export var playerIndex : int = 0
@export var inputProfile : PlayerInputProfile

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
	set_collision_layer_value(PhysicsLayers.PLAYER_PRESENCE, true)
	assert(whipAttackSpawner != null, "WhipAttackSpawner should not be null" )
	hp = maxHp
	died.connect(_onDied)

func _onDied() -> void:
	EventBus.playerDied.emit(playerIndex)

func getQuickSlotItemID(index : GlobalConstants.QuickSlotIndices) -> GlobalConstants.ItemIndices:
	return GlobalStates.session.getQuickSlotItem(playerIndex, index)

# there could be other conditions here later if needed
func canQuickSlotItemBeUsed(index : GlobalConstants.QuickSlotIndices) -> bool:
	return GlobalStates.session.getItemCount(getQuickSlotItemID(index)) >= 1

func takeDamage(amount: int, source: Node2D = null) -> void:
	if isBlocking and source != null:
		var hitFrom := Facing.fromDominantAxis(source.global_position - global_position)
		if facing == hitFrom:
			return
	hp -= amount
	hp = clamp(hp - 1, 0, maxHp)
	if hp <= 0:
		died.emit()
	damaged.emit(amount)

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

# while dashing, enemies, attacks and the other player pass through the player
func dash() -> void:
	set_collision_layer_value(PhysicsLayers.PLAYER, false)
	playDirectional("dash")

func stopDash() -> void:
	set_collision_layer_value(PhysicsLayers.PLAYER, true)
	idleAnimation()

func whipAttack(attackDelay):
	var whip = whipAttackSpawner.instantiate()
	whip.global_position = spawnLocationWhipAttack.global_position
	whip.rotation = attackPivotPoint.rotation
	whip.goal = goalWhipAttackGoal.global_position
	whip.attackDelay = attackDelay
	whip.playerIndex = playerIndex

	get_parent().add_child(whip)

func stopWhipAttack():
	idleAnimation()

func setInteractable(object : WorldObject) -> void:
	interactableObject = object
