class_name Wizard extends Enemy

@onready var atkSpawnPoint: Node2D = $AtkSpawnPoint

@export var fireballScene : PackedScene = null
@export var panicRunThresholdDistance := 300
@export var runChance := 0.7
@export var SPEED := 100

@onready var projectileNode: Node = get_tree().get_first_node_in_group("ProjectileNode")

func attack() -> void:
	var fireball = fireballScene.instantiate()
	var atkDirection = global_position.direction_to(target.global_position)
	atkSpawnPoint.global_position = global_position + atkDirection * 100
	fireball.global_position = atkSpawnPoint.global_position
	fireball.direction = fireball.global_position.direction_to(target.global_position)
	projectileNode.add_child(fireball)
	playDirectional("attack")
