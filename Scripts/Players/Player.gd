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

func takeDamage(dmg):
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

# blocks in facing direction
func blockIdleAnimation() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("blockBack")
		Direction.DOWN:
			animatedSprite.play("blockFront")
		Direction.LEFT:
			animatedSprite.play("blockLeft")
		Direction.RIGHT:
			animatedSprite.play("blockRight")
			
func blockRunAnimation() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("blockBack")
		Direction.DOWN:
			animatedSprite.play("blockFront")
		Direction.LEFT:
			animatedSprite.play("blockLeft")
		Direction.RIGHT:
			animatedSprite.play("blockRight")

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

func whipAttack(attackDelay):

	var whip = whipAttackSpawner.instantiate()
	whip.global_position = spawnLocationWhipAttack.global_position
	whip.rotation = attackPivotPoint.rotation
	whip.goal = goalWhipAttackGoal.global_position
	whip.attackDelay = attackDelay
	whip.player = self
	
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

func setInteractable(object):
	interactableObject = object
