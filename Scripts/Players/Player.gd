class_name Player extends CharacterBody2D

signal playerDeath
signal playerTakesDamage

@export var maxHp = 6
@export var hp = 6

@onready var stateMachine = $StateMachine
@export var ItemQuickSlots : ItemQuickSelect

@onready var attackPivotPoint : Node2D = $AttackPivotPoint

@export var whipAttackSpawner : PackedScene =  null
@onready var spawnLocationWhipAttack = $AttackPivotPoint/WhipAttack/Start 
@onready var goalWhipAttackGoal = $AttackPivotPoint/WhipAttack/Goal

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

# this is set by an object when getting close enough to it's interact range
# null means there is none right now
# the state machine checks this when the interact button is pressed
var interactableObject = null
var isBlocking :bool = false

var DIRECTION = GlobalConstants.Direction
var facingDirection = DIRECTION.DOWN

func _ready() -> void:
	assert(ItemQuickSlots != null, "ItemQuickSlots should not be null")
	assert(whipAttackSpawner != null, "WhipAttackSpawner should not be null" )
	playerDeath.connect(EventHandler.playerDied)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func getQuickSlotItemID(index : GlobalConstants.QuickSlotIndices):
	return ItemQuickSlots.quickSlots[index].id

# there could be other conditions here later if needed
func canQuickSlotItemBeUsed(index : GlobalConstants.QuickSlotIndices):
	return ItemQuickSlots.quickSlots[index].itemAmount >= 1

func takeDamage(dmg, dmgSource: Node2D):
	#direction from player -> damage source
	var dmgDir = dmgSource.global_position - global_position
	if abs(dmgDir.x) > abs(dmgDir.y):
		dmgDir = DIRECTION.LEFT if dmgDir.x < 0 else DIRECTION.RIGHT
	else:
		dmgDir = DIRECTION.UP if dmgDir.y < 0 else DIRECTION.DOWN
	if(isBlocking && facingDirection == dmgDir):
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
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("attackBack" + suffix)
		DIRECTION.DOWN:
			animatedSprite.play("attackFront" + suffix)
		DIRECTION.LEFT:
			animatedSprite.play("attackLeft" + suffix)
		DIRECTION.RIGHT:
			animatedSprite.play("attackRight" + suffix)

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

func dash() -> void:
	collision_layer = collision_layer & 0b0 #become unhittable
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("dashBack")
		DIRECTION.DOWN:
			animatedSprite.play("dashFront")
		DIRECTION.LEFT:
			animatedSprite.play("dashLeft")
		DIRECTION.RIGHT:
			animatedSprite.play("dashRight")

func stopDash() -> void:
	collision_layer = collision_layer | 0b1 #become hittable
	match facingDirection:
		DIRECTION.UP:
			animatedSprite.play("idleBack")
		DIRECTION.DOWN:
			animatedSprite.play("idleFront")	
		DIRECTION.LEFT:
			animatedSprite.play("idleLeft")
		DIRECTION.RIGHT:
			animatedSprite.play("idleRight")

func whipAttack(attackDelay):

	var whip = whipAttackSpawner.instantiate()
	whip.global_position = spawnLocationWhipAttack.global_position
	whip.rotation = attackPivotPoint.rotation
	whip.goal = goalWhipAttackGoal.global_position
	whip.attackDelay = attackDelay
	whip.player = self
	
	get_parent().add_child(whip)

func stopWhipAttack():
		match facingDirection:
			DIRECTION.UP:
				animatedSprite.play("idleBack")
			DIRECTION.DOWN:
				animatedSprite.play("idleFront")	
			DIRECTION.LEFT:
				animatedSprite.play("idleLeft")
			DIRECTION.RIGHT:
				animatedSprite.play("idleRight")

func setInteractable(object):
	interactableObject = object
