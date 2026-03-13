extends CharacterBody2D


@export var SPEED = 10.0

var targetLocation = Vector2.ZERO
var players =[]

func _ready() -> void:
	players = get_tree().get_nodes_in_group("Players")

func _process(delta: float) -> void:
	if players.is_empty():
		return
	
	if players.size() == 2:
		targetLocation = (players[0].global_position + players[1].global_position) / 2
	elif players.size() == 1:
		targetLocation = players[0].global_position

func _physics_process(_delta: float) -> void:
	velocity = global_position.direction_to(targetLocation) * global_position.distance_to(targetLocation) * SPEED
	velocity.clamp(Vector2(-SPEED, -SPEED), Vector2(SPEED, SPEED))
	move_and_slide()
