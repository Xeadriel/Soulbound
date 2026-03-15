class_name StateEnemy extends State

@onready var players

@export var entity: Enemy = null

const IDLE = "StateIdle"
const RUN = "StateRun"
const ATK = "StateAtk"
const RUNCIRCLE = "StateRunCircle"
const TELEGRAPH = "StateTelegraph"
const STUNNED = "StateTelegraph"

enum inRangeBehavior {ATK, CIRCLE}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(entity != null, "Entity should not be null")
	assert(owner is Enemy, "StateEnemy Class belongs only to Enemy class!")
	players = get_tree().get_nodes_in_group("Players")

func enter(_previous_state_path: String, _data := {}):
	pass

func getClosestPlayer() -> Player:
	var closestPlayer: Player
	var closestDistance = INF
	for p in players:
		var distanceToPlayer = p.global_position.distance_to(entity.global_position)
		if(distanceToPlayer < closestDistance):
			closestDistance = distanceToPlayer
			closestPlayer = p
	return closestPlayer

func getDistanceSelf2Target():
	return entity.target.global_position.distance_to(entity.global_position)
