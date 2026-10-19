class_name EliteWizard extends Enemy

@onready var atkSpawnPoint: Node2D = $AtkSpawnPoint

@export var fireballScene : PackedScene = null

@export var panicRunThresholdDistance := 300
@export var runChance := 1

@export var teleportLocationsRoot : Node2D

## How much shorter the telegraph gets per hit while stunned, in seconds.
const TELEGRAPH_SPEEDUP := 0.2
## The telegraph never gets shorter than this, in seconds.
const MIN_TELEGRAPH_DURATION := 0.4
@onready var teleportLocations : Array = teleportLocationsRoot.get_children()

func _ready() -> void:
	super._ready()
	assert(not teleportLocationsRoot == null, "Need a root Node2D that contains Node2Ds that provide
													all possible teleport locations to the wizard")

func takeDamage(amount: int, _source: Node2D = null) -> void:
	if stateMachine.currentState.name == StateEnemy.STUNNED:
		hp -= amount
		speedUpTelegraph()
		teleport()
	else:
		teleport()
		stateMachine.interrupt(StateEnemy.TAUNT)

## Each hit while stunned makes the telegraph shorter, down to MIN_TELEGRAPH_DURATION.
func speedUpTelegraph() -> void:
	var telegraph : StateEnemyAnimated = stateMachine.get_node(StateEnemy.TELEGRAPH)
	telegraph.duration = maxf(MIN_TELEGRAPH_DURATION, telegraph.duration - TELEGRAPH_SPEEDUP)

func teleport():
	var randomIndex = randi() % len(teleportLocations)
	while global_position == teleportLocations[randomIndex].global_position:
		randomIndex = randi() % len(teleportLocations)

	global_position = teleportLocations[randomIndex].global_position

func attack() -> void:
	var fireball = fireballScene.instantiate()
	var atkDirection = global_position.direction_to(target.global_position)
	atkSpawnPoint.global_position = global_position + atkDirection * 100
	fireball.global_position = atkSpawnPoint.global_position
	fireball.direction = fireball.global_position.direction_to(target.global_position)
	Projectile.spawnParent(get_tree()).add_child(fireball)
