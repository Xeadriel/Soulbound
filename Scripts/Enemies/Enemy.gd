class_name Enemy extends Character

@export var atkRange := 100.0
@export var aggroRange:= 500.0
@export var telegraphTime := 1.0
@export var atkTime := 1.0

var players
var target: Player

@onready var attackUp : Area2D = $AttackUp
@onready var attackDown : Area2D = $AttackDown
@onready var attackLeft : Area2D = $AttackLeft
@onready var attackRight : Area2D = $AttackRight

@export var DAMAGE = 1

func _ready() -> void:
	# rooms are disabled by default, entering activates enemy
	process_mode = PROCESS_MODE_INHERIT
	hp = maxHp
	players = get_tree().get_nodes_in_group("Players")

func _physics_process(delta: float) -> void:
	# enemies become room independent once they are activated
	process_mode = PROCESS_MODE_PAUSABLE
	super._physics_process(delta)

func _onHpChanged() -> void:
	if hp < 1:
		died.emit()
		queue_free()

func takeDamage(dmg: int) -> void:
	hp -= dmg

func hitByWhip():
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
	pass

func telegraphAttack() -> void:
	playDirectional("telegraph")

# signal when area2D collides with something
func hitSomething(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.takeDamage(DAMAGE, self)
