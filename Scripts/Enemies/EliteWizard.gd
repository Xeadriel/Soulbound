class_name EliteWizard extends Enemy

@onready var atkSpawnPoint: Node2D = $AtkSpawnPoint

@export var fireballScene : PackedScene = null
@onready var projectileNode: Node = get_tree().get_first_node_in_group("ProjectileNode")

@export var panicRunThresholdDistance := 300
@export var runChance := 1

@export var teleportLocationsRoot : Node2D
@onready var teleportLocations : Array = teleportLocationsRoot.get_children()

func _ready() -> void:
	super._ready()
	assert(not teleportLocationsRoot == null, "Need a root Node2D that contains Node2Ds that provide
													all possible teleport locations to the wizard")

func takeDamage(dmg: int) -> void:
	var state = stateMachine.currentState
	if state.name == state.STUNNED:
		hp -= dmg
		atkTime += 0.2
		telegraphTime += 0.2
		teleport()
	else:
		teleport()
		stateMachine.interrupt(StateEnemy.TAUNT)

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
	projectileNode.add_child(fireball)

	playDirectional("attack")
