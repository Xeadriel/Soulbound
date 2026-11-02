class_name Wizard extends Enemy

@onready var atkSpawnPoint: Node2D = $AtkSpawnPoint

@export var fireballScene : PackedScene = null
@export var panicRunThresholdDistance := 150
@export var runChance := 0.7
@export var SPEED := 50

func attack() -> void:
	var fireball = fireballScene.instantiate()
	var atkDirection = global_position.direction_to(target.global_position)
	atkSpawnPoint.global_position = global_position + atkDirection * 50
	fireball.global_position = atkSpawnPoint.global_position
	fireball.direction = fireball.global_position.direction_to(target.global_position)
	Projectile.spawnParent(get_tree()).add_child(fireball)
