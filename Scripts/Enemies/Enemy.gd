class_name Enemy extends Character

@export var atkRange := 100.0
@export var aggroRange:= 500.0
@export var telegraphTime := 1.0
@export var atkTime := 1.0

var players
var target: Player

## Melee hitboxes, only present on enemies with melee attacks.
@onready var meleeHitboxes : DirectionalHitboxes = get_node_or_null("MeleeHitboxes")

@export var DAMAGE = 1

func _ready() -> void:
	hp = maxHp
	players = get_tree().get_nodes_in_group("Players")
	# until our room wakes up we only idle: body, hitbox and idle animation stay live,
	# but the state machine (aggro, attacks) doesn't start
	var room := Room.containing(self)
	if room != null and not room.isAwake:
		stateMachine.startOnReady = false
		idle()
		room.awakened.connect(wake, CONNECT_ONE_SHOT)

## Lets the enemy start fighting.
func wake() -> void:
	stateMachine.start()

func _onHpChanged() -> void:
	if hp < 1:
		died.emit()
		queue_free()

func takeDamage(amount: int, _source: Node2D = null) -> void:
	hp -= amount

## Called when an item hitbox (see ItemHitbox) hits this enemy.
func onItemHit(item: GlobalConstants.ItemIndices, _playerIndex: int) -> void:
	match item:
		GlobalConstants.ItemIndices.WHIP:
			stateMachine.interrupt(StateEnemy.STUNNED, {"duration" : 1.0})

func getDirectionToPlayer() -> Facing.Direction:
	return Facing.fromVector(global_position.direction_to(target.global_position))

func getClosestPlayer() -> Player:
	var closestPlayer: Player
	var closestDistance = INF
	for p in players:
		var distanceToPlayer = p.global_position.distance_to(global_position)
		if(distanceToPlayer < closestDistance):
			closestDistance = distanceToPlayer
			closestPlayer = p
	return closestPlayer

# --- animations ---

func idle():
	playDirectional("idle")

func stunned():
	playDirectional("stunned")

func run():
	playDirectional("run")

func stopAttack() -> void:
	if meleeHitboxes != null:
		meleeHitboxes.disableAll()

func telegraphAttack() -> void:
	playDirectional("telegraph")

# signal when area2D collides with something
func hitSomething(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.takeDamage(DAMAGE, self)
